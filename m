Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF097411BEE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345667AbhITREG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245413AbhITRB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EEFA6137F;
        Mon, 20 Sep 2021 16:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156811;
        bh=oyLOSIVASuQSXrbHxkz62uBgMEAL4jGn252Izme2//I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usS2UC+Z/sqxTkedEht0MSchxE67PJJ9rNpUn6FOXsc0zI8e8CdVWCG552Ml+igyo
         VJQFCQGwIl9IOD8ItF8RwpLF7FBLNWeZ9NREfrFlZfYHt29o8s7JoBvmOusro9eyd8
         VFAeczZJdR7tjmZFJAEdx97O3lGnHAVyKrZTgGoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.9 096/175] media: rc-loopback: return number of emitters rather than error
Date:   Mon, 20 Sep 2021 18:42:25 +0200
Message-Id: <20210920163921.216058907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 6b7f554be8c92319d7e6df92fd247ebb9beb4a45 upstream.

The LIRC_SET_TRANSMITTER_MASK ioctl should return the number of emitters
if an invalid list was set.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-loopback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -55,7 +55,7 @@ static int loop_set_tx_mask(struct rc_de
 
 	if ((mask & (RXMASK_REGULAR | RXMASK_LEARNING)) != mask) {
 		dprintk("invalid tx mask: %u\n", mask);
-		return -EINVAL;
+		return 2;
 	}
 
 	dprintk("setting tx mask: %u\n", mask);


