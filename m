Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF3814BC03
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgA1Oug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:50:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgA1N7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:59:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6137724683;
        Tue, 28 Jan 2020 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219940;
        bh=xPJ4DVVjuH7+QRs/g3mZ9AXjGQdLwflaajAmAbDLLC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7Lf81ORGG/ExtlrzfoyXOZ0YKGIyTB1kYOsXFO1j2C+SEHd22owBmFMNf8bwWY7r
         GHUBJI4hXG0ovKQVpp6zBhF+WzlHmPvTiSKfI0cwseC/zN6BQyMD50pjQliQMr6ens
         i/BRmJAr7f0ioAopsBXPJh1nM66/CUPI7L9IeUEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Timo Kaufmann <timokau@zoho.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 22/46] Revert "Input: synaptics-rmi4 - dont increment rmiaddr for SMBus transfers"
Date:   Tue, 28 Jan 2020 14:57:56 +0100
Message-Id: <20200128135752.743656510@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
References: <20200128135749.822297911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 8ff771f8c8d55d95f102cf88a970e541a8bd6bcf upstream.

This reverts commit a284e11c371e446371675668d8c8120a27227339.

This causes problems (drifting cursor) with at least the F11 function that
reads more than 32 bytes.

The real issue is in the F54 driver, and so this should be fixed there, and
not in rmi_smbus.c.

So first revert this bad commit, then fix the real problem in F54 in another
patch.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Timo Kaufmann <timokau@zoho.com>
Fixes: a284e11c371e ("Input: synaptics-rmi4 - don't increment rmiaddr for SMBus transfers")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200115124819.3191024-2-hverkuil-cisco@xs4all.nl
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_smbus.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/rmi4/rmi_smbus.c
+++ b/drivers/input/rmi4/rmi_smbus.c
@@ -166,6 +166,7 @@ static int rmi_smb_write_block(struct rm
 		/* prepare to write next block of bytes */
 		cur_len -= SMB_MAX_COUNT;
 		databuff += SMB_MAX_COUNT;
+		rmiaddr += SMB_MAX_COUNT;
 	}
 exit:
 	mutex_unlock(&rmi_smb->page_mutex);
@@ -217,6 +218,7 @@ static int rmi_smb_read_block(struct rmi
 		/* prepare to read next block of bytes */
 		cur_len -= SMB_MAX_COUNT;
 		databuff += SMB_MAX_COUNT;
+		rmiaddr += SMB_MAX_COUNT;
 	}
 
 	retval = 0;


