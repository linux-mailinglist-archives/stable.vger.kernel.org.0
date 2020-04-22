Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129321B478E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgDVOn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 10:43:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53391 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726066AbgDVOn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 10:43:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587566637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=X1m+KyBEjIchG4rjXeDIQpyNNPLZZU2rr+C9a+kRM8A=;
        b=dIx1SMB2EVz+ClTo3jWDp3L5NIMBaCX3RsfBtzaNl0cakBoy4wvsl5se9w/lp9mLW1lh/W
        dDhnDBKEccjq/w1nsRVrGASV2Ls8lR0DdXOdTlYbwrooXRK/rB24NnZHKKV76h0tJtlbEM
        nwP5XcvUwwhL0wGm22rxJKcU4mGdkuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-hpjANUAGM--r1Tc4Vd1P2A-1; Wed, 22 Apr 2020 10:43:50 -0400
X-MC-Unique: hpjANUAGM--r1Tc4Vd1P2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22DA6801504;
        Wed, 22 Apr 2020 14:43:49 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-113-5.ams2.redhat.com [10.36.113.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF411600DE;
        Wed, 22 Apr 2020 14:43:47 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        Naoki Kiryu <naonaokiryu2@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] usb: typec: altmode: Fix typec_altmode_get_partner sometimes returning an invalid pointer
Date:   Wed, 22 Apr 2020 16:43:45 +0200
Message-Id: <20200422144345.43262-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoki Kiryu <naonaokiryu2@gmail.com>

Before this commit, typec_altmode_get_partner would return a
const struct typec_altmode * pointing to address 0x08 when
to_altmode(adev)->partner was NULL.

Add a check for to_altmode(adev)->partner being NULL to fix this.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D206365
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1785972
Fixes: 5f54a85db5df ("usb: typec: Make sure an alt mode exist before gett=
ing its partner")
Cc: stable@vger.kernel.org
Signed-off-by: Naoki Kiryu <naonaokiryu2@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/typec/bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/bus.c b/drivers/usb/typec/bus.c
index c823122f9cb7..e8ddb81cb6df 100644
--- a/drivers/usb/typec/bus.c
+++ b/drivers/usb/typec/bus.c
@@ -198,7 +198,10 @@ EXPORT_SYMBOL_GPL(typec_altmode_vdm);
 const struct typec_altmode *
 typec_altmode_get_partner(struct typec_altmode *adev)
 {
-	return adev ? &to_altmode(adev)->partner->adev : NULL;
+	if (!adev || !to_altmode(adev)->partner)
+		return NULL;
+
+	return &to_altmode(adev)->partner->adev;
 }
 EXPORT_SYMBOL_GPL(typec_altmode_get_partner);
=20
--=20
2.26.0

