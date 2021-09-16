Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2872440E552
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345068AbhIPRK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349943AbhIPRH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:07:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA05660EFF;
        Thu, 16 Sep 2021 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810200;
        bh=JFIwOmiBvrlHVlUc/agg+VHNpbDgXFBJyCKiIIAbcSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBoXDuAT5n+Ab0C3RhJxCwW35u3PL28RQE1yZuhuJmTqxOH0i0NdpA7paCrFjfj5R
         e0IhsWbY7jg4+tFo6XhVepVhA71a2viS1Siv2czxFIcZSlOeRIhSM25GesJaQaF/XA
         vjHPcanPS7/1AJ4bda8PF6Tq4jWXywO8S/w0ik9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.14 052/432] media: rc-loopback: return number of emitters rather than error
Date:   Thu, 16 Sep 2021 17:56:41 +0200
Message-Id: <20210916155812.566908842@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
@@ -42,7 +42,7 @@ static int loop_set_tx_mask(struct rc_de
 
 	if ((mask & (RXMASK_REGULAR | RXMASK_LEARNING)) != mask) {
 		dprintk("invalid tx mask: %u\n", mask);
-		return -EINVAL;
+		return 2;
 	}
 
 	dprintk("setting tx mask: %u\n", mask);


