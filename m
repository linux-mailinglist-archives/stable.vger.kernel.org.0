Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D418611D5
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfGFPTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 11:19:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfGFPTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Jul 2019 11:19:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83CDC86658;
        Sat,  6 Jul 2019 15:19:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38CF717102;
        Sat,  6 Jul 2019 15:19:03 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 081E44E9E2;
        Sat,  6 Jul 2019 15:19:02 +0000 (UTC)
Date:   Sat, 6 Jul 2019 11:19:02 -0400 (EDT)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+79337b501d6aa974d0f6@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@intel.com>,
        Ilya Faenson <ifaenson@broadcom.com>
Message-ID: <1938318038.39428333.1562426342706.JavaMail.zimbra@redhat.com>
In-Reply-To: <37673EE8-2391-425D-9957-D6FDAEFB03FA@holtmann.org>
References: <20190625173215.25999-1-vdronov@redhat.com> <37673EE8-2391-425D-9957-D6FDAEFB03FA@holtmann.org>
Subject: Re: [PATCH] Bluetooth: hci_ldisc: check for missing tty operations
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.2.20, 10.4.195.25]
Thread-Topic: Bluetooth: hci_ldisc: check for missing tty operations
Thread-Index: Y6PSNA1ggdS0XuGkMbW9gMaqSx7KUg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Sat, 06 Jul 2019 15:19:03 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Marcel,

I totally agree, the same came to my mind some time after sending the patch.
Let me send a v2 in a while with drivers checking for needed tty operations
presence.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

----- Original Message -----
> From: "Marcel Holtmann" <marcel@holtmann.org>
> To: "Vladis Dronov" <vdronov@redhat.com>
> Cc: "Johan Hedberg" <johan.hedberg@gmail.com>, linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
> syzbot+79337b501d6aa974d0f6@syzkaller.appspotmail.com, stable@vger.kernel.org, "Loic Poulain"
> <loic.poulain@intel.com>, "Ilya Faenson" <ifaenson@broadcom.com>
> Sent: Saturday, July 6, 2019 12:35:39 PM
> Subject: Re: [PATCH] Bluetooth: hci_ldisc: check for missing tty operations
> 
> Hi Vladis,
> 
> > Certain ttys lack operations (eg: pty_unix98_ops) which still can be
> > called by certain hci uart proto (eg: mrvl, ath). Currently this leads
> > to execution at address 0x0. Fix this by adding checks for missing tty
> > operations.
> 
> so I really prefer that we just fail setting the line discipline. These
> drivers need to check that the underlying transport has all the operations
> available they need. We can not just ignore them.
> 
> Regards
> 
> Marcel
