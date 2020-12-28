Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB952E3821
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgL1NFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbgL1NFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:05:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A8B122B3A;
        Mon, 28 Dec 2020 13:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160710;
        bh=vZLDLd/hTUPshAafKNY7RcLwYleHWBITfHEg2udMb1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EANO5BIPbO6pCFN+5jCgkK7GBeMpVx11bVcVyT5MUvr9Zog06jxT4YczcmYb8vQ10
         1qis3uS9kBKQ/bCPI/LvZ5qykdgZRacaFzljWuaJwyoyKKC5px5yZpOD1+kqMaYWXk
         wnhbWa6+zu8rSIV2RAhQKyKaJW9vQdDRSAGV0Xlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 144/175] USB: serial: mos7720: fix parallel-port state restore
Date:   Mon, 28 Dec 2020 13:49:57 +0100
Message-Id: <20201228124900.226664728@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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


