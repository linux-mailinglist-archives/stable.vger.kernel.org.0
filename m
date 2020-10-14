Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EFA28E26C
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgJNOmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 10:42:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729153AbgJNOmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 10:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602686529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AyWfiZ87mZMggRfQO4NsuqE5LIObC7zu63xuUqiKqPA=;
        b=CSwKIiqb/uPdCHKipnfEEBy4QzjSPAlpykvOITvDIDsKUhadiXSdqI2TzgAzsDISkHUwGw
        HayDlGyrDcV9pVQNgOvpxaBEiV3Aq3R84adpUURwDpZrTHA4bkHV4ilnc95/uCOlIIfIeD
        811qYUNBbXrr4pbYq7PilrHJUu+mEsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-G-VBpyUcP4iS7GWHal35ww-1; Wed, 14 Oct 2020 10:42:04 -0400
X-MC-Unique: G-VBpyUcP4iS7GWHal35ww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A4158030AE;
        Wed, 14 Oct 2020 14:42:02 +0000 (UTC)
Received: from x1.localdomain (ovpn-112-126.ams2.redhat.com [10.36.112.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 219D77BE43;
        Wed, 14 Oct 2020 14:41:59 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH 5.8+ regression fix 0/1] i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs
Date:   Wed, 14 Oct 2020 16:41:57 +0200
Message-Id: <20201014144158.18036-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi All,

I am afraid that commit 21653a4181ff ("i2c: core: Call
i2c_acpi_install_space_handler() before i2c_acpi_register_devices()")
which is in 5.9 and was also added to 5.8.13 (and possible other
stable series releases) causes a regression on some devices including
on the Microsoft Surface Go 2 (and possibly also the Go 1) where the
system no longer boots.

Before the troublesome commit the ACPI related i2c core code looked
like this:

        /* create pre-declared device nodes */
        of_i2c_register_devices(adap);
        i2c_acpi_register_devices(adap);
        i2c_acpi_install_space_handler(adap);

	if (...

The trouble some commit changed this to:

        /* create pre-declared device nodes */
        of_i2c_register_devices(adap);
        i2c_acpi_install_space_handler(adap);
        i2c_acpi_register_devices(adap);

	if (...

The goal here was to only move the acpi_install_address_space_handler()
which is wrapped by i2c_acpi_install_space_handler() which should be
pretty safe. But as Maximilian Luz' sharp eyes pointed out while
debugging the regression, i2c_acpi_install_space_handler() does more,
it also contains a call to acpi_walk_dep_device_list() at the end.
Which I missed and which is causing the trouble we are seeing now.

The original code flow looked like this:

1.  i2c_acpi_register_devices()
1.1  Create ACPI declared i2c_clients for adap
2.  i2c_acpi_install_space_handler(adap);
2.1  acpi_install_address_space_handler()
2.2  acpi_walk_dep_device_list()

And after the troublesome commit it now looks like this:

1.  i2c_acpi_install_space_handler(adap);
1.1  acpi_install_address_space_handler()
1.2  acpi_walk_dep_device_list()
2.  i2c_acpi_register_devices()
2.1  Create ACPI declared i2c_clients for adap

Notice that the acpi_walk_dep_device_list() now happens before
the i2c_clients below this adapter are created.

The patch in this 1 patch series fixes this by moving the
acpi_walk_dep_device_list() call to the end of
i2c_acpi_register_devices(), partly restoring the original
order, so that we now get:

1.  i2c_acpi_install_space_handler(adap);
1.1  acpi_install_address_space_handler()
2.  i2c_acpi_register_devices()
2.1  Create ACPI declared i2c_clients for adap
2.2  acpi_walk_dep_device_list()

So we end up calling acpi_walk_dep_device_list() last
again, as before.

Sorry for missing this the first time around.

Wolfram, can we get this queued up to go to Linus
soonish ?

Greg, in essence this is a partial revert of the trouble
some commit. With the 2 combined acpi_walk_dep_device_list()
is called last again, while still doing the
acpi_install_address_space_handler() call earlier.

Since this is a somewhat nasty regression and since the poor
timing wrt the merge-window, I was hoping that you would be
willing to make an exception and pick up this fix before
it hits Linus' tree?

The alternative would be to revert this now and then pick
up both again later, when the fix has landed in Linus'
tree. The problem with that is that reverting the original
troublesome commit will regress all these bugs:

https://bugzilla.redhat.com/show_bug.cgi?id=1842039
https://bugzilla.redhat.com/show_bug.cgi?id=1871793
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1861610

Regards,

Hans

