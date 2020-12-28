Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E832E691C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634638AbgL1Qon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbgL1M5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:57:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A58322583;
        Mon, 28 Dec 2020 12:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160218;
        bh=vZLDLd/hTUPshAafKNY7RcLwYleHWBITfHEg2udMb1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0rEJ8bGDVNu4thhw3BsmET5nphv+sqm7C+OxtpPgq6VRM/6uIXbvJJ1RCrbaIVNM
         +b1DOzrOxn2p1MKT3AA56xVq9QfWXHDWfmNFbHPTiBs8ghoqpTDx1OH+ZeXfySdpme
         xxr5qndImiNptAM3YzhzQbkdH61MbXKpSVJaG1aY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 108/132] USB: serial: mos7720: fix parallel-port state restore
Date:   Mon, 28 Dec 2020 13:49:52 +0100
Message-Id: <20201228124851.635088354@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 975323ab8f116667676c30ca3502a6757bd89e8d upstream.

The parallel-port restore operations is called when a driver claims the
port and is supposed to restore the provided state (e.g. saved when
releasing the port).

Fixes: b69578df7e98 ("USB: usbserial: mos7720: add support for parallel port on moschip 7715")
Cc: stable <stable@vger.kernel.org>     # 2.6.35
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7720.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -640,6 +640,8 @@ static void parport_mos7715_restore_stat
 		spin_unlock(&release_lock);
 		return;
 	}
+	mos_parport->shadowDCR = s->u.pc.ctr;
+	mos_parport->shadowECR = s->u.pc.ecr;
 	write_parport_reg_nonblock(mos_parport, MOS7720_DCR,
 				   mos_parport->shadowDCR);
 	write_parport_reg_nonblock(mos_parport, MOS7720_ECR,


