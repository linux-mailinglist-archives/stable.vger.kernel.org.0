Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD747F37E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406959AbfHBJ5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406955AbfHBJ5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C1C20665;
        Fri,  2 Aug 2019 09:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739860;
        bh=5gFN0wq/rmOKHnzopRnftg549PVRc0PdvWiv2ZWBDXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah6oc95vcmz3g7x2IpfP49Sh45sRM3EJ2dMh1ghKh/srXZUXIXp1mH4y7kMCw/+Pb
         nUVXQaIdU2t5slTyOfl2I3vpZZ0YVE/pccJh/vO7QXIy3LqQ24FUmpeSgdMRLMT64Y
         M1kJ11zaJh3e2IKXX1JJw1RcU2q8sGJUF7LlDO/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Greg KH <greg@kroah.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 18/20] drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl
Date:   Fri,  2 Aug 2019 11:40:12 +0200
Message-Id: <20190802092103.554394372@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

commit 5515e9a6273b8c02034466bcbd717ac9f53dab99 upstream.

The PPS assert/clear offset corrections are set by the PPS_SETPARAMS
ioctl in the pps_ktime structs, which also contain flags.  The flags are
not initialized by applications (using the timepps.h header) and they
are not used by the kernel for anything except returning them back in
the PPS_GETPARAMS ioctl.

Set the flags to zero to make it clear they are unused and avoid leaking
uninitialized data of the PPS_SETPARAMS caller to other applications
that have a read access to the PPS device.

Link: http://lkml.kernel.org/r/20190702092251.24303-1-mlichvar@redhat.com
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: Greg KH <greg@kroah.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pps/pps.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -152,6 +152,14 @@ static long pps_cdev_ioctl(struct file *
 			pps->params.mode |= PPS_CANWAIT;
 		pps->params.api_version = PPS_API_VERS;
 
+		/*
+		 * Clear unused fields of pps_kparams to avoid leaking
+		 * uninitialized data of the PPS_SETPARAMS caller via
+		 * PPS_GETPARAMS
+		 */
+		pps->params.assert_off_tu.flags = 0;
+		pps->params.clear_off_tu.flags = 0;
+
 		spin_unlock_irq(&pps->lock);
 
 		break;


