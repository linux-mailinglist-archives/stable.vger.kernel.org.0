Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B36314B972
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387507AbgA1Ob7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733276AbgA1O1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B4E24688;
        Tue, 28 Jan 2020 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221632;
        bh=xPJ4DVVjuH7+QRs/g3mZ9AXjGQdLwflaajAmAbDLLC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9M8RhULf8IsPzrF6oH8n2+2WBQq2W7uKYxY8jk4w46568nUJKEmJAOeNonnMmYVt
         rt1IgiIx120Wgi8TNWKXV5CwL+IkyoNkOHttv9dCTWzzXooYYtlYlTQJJXqAOlh5sd
         U7aoKhnWPk275N1lo/u9Ru2qBcBQ4VrNlJCOv3tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Timo Kaufmann <timokau@zoho.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 28/92] Revert "Input: synaptics-rmi4 - dont increment rmiaddr for SMBus transfers"
Date:   Tue, 28 Jan 2020 15:07:56 +0100
Message-Id: <20200128135812.642298369@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
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


