Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A5211B7FB
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfLKPKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730781AbfLKPKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:10:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF87B2173E;
        Wed, 11 Dec 2019 15:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077037;
        bh=8fXR3pDHRmhmejxjqkM7w/Bbc1ZTBgKxvue1qmh4iVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s50IHzHkDglSlvfE52Ogg8w1FdvO3ePsygjVgsy+7O82pHeQk1K1gkrk5AddbYRfG
         DIIylw3jgwtRoG/9qY5GQK//hO/XqmjyVYeVWF2AIfxih0c1NJfhxJgWVeHrRUkhIL
         BPtWtmSnNb7LiV0hPlhAhBOi6LrOiow+O64AmSBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 39/92] Input: synaptics-rmi4 - dont increment rmiaddr for SMBus transfers
Date:   Wed, 11 Dec 2019 16:05:30 +0100
Message-Id: <20191211150239.302941211@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit a284e11c371e446371675668d8c8120a27227339 upstream.

This increment of rmi_smbus in rmi_smb_read/write_block() causes
garbage to be read/written.

The first read of SMB_MAX_COUNT bytes is fine, but after that
it is nonsense. Trial-and-error showed that by dropping the
increment of rmiaddr everything is fine and the F54 function
properly works.

I tried a hack with rmi_smb_write_block() as well (writing to the
same F54 touchpad data area, then reading it back), and that
suggests that there too the rmiaddr increment has to be dropped.
It makes sense that if it has to be dropped for read, then it has
to be dropped for write as well.

It looks like the initial work with F54 was done using i2c, not smbus,
and it seems nobody ever tested F54 with smbus. The other functions
all read/write less than SMB_MAX_COUNT as far as I can tell, so this
issue was never noticed with non-F54 functions.

With this change I can read out the touchpad data correctly on my
Lenovo X1 Carbon 6th Gen laptop.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Link: https://lore.kernel.org/r/8dd22e21-4933-8e9c-a696-d281872c8de7@xs4all.nl
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_smbus.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/input/rmi4/rmi_smbus.c
+++ b/drivers/input/rmi4/rmi_smbus.c
@@ -163,7 +163,6 @@ static int rmi_smb_write_block(struct rm
 		/* prepare to write next block of bytes */
 		cur_len -= SMB_MAX_COUNT;
 		databuff += SMB_MAX_COUNT;
-		rmiaddr += SMB_MAX_COUNT;
 	}
 exit:
 	mutex_unlock(&rmi_smb->page_mutex);
@@ -215,7 +214,6 @@ static int rmi_smb_read_block(struct rmi
 		/* prepare to read next block of bytes */
 		cur_len -= SMB_MAX_COUNT;
 		databuff += SMB_MAX_COUNT;
-		rmiaddr += SMB_MAX_COUNT;
 	}
 
 	retval = 0;


