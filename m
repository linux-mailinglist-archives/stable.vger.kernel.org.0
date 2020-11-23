Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35CC2C0592
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgKWMXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729618AbgKWMXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:23:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09DB920888;
        Mon, 23 Nov 2020 12:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134211;
        bh=YoQDnUTsqVY+WKspD6+ZqPA26Klmis3QpVjN5O9GZjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paXbZNWalU2raF8wKMqFMEuR2XRTu1P3YbahAm/8joVZsAGJ8Z44r+YKaGa+u8zOq
         EPKCb7MAmqOTnGcLIB8sZG7VcaTCVIsHPhzf9eo1avIC8FpDxAlFNfv889jEWB7Ga5
         BrgqkCR7HtnkAPKYCAGkg3e+z+EtBB5ujwIl4gaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 28/38] ALSA: mixart: Fix mutex deadlock
Date:   Mon, 23 Nov 2020 13:22:14 +0100
Message-Id: <20201123121805.650696712@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d21b96c8ed2aea7e6b7bf4735e1d2503cfbf4072 upstream.

The code change for switching to non-atomic mode brought the
unexpected mutex deadlock in get_msg().  It converted the spinlock
with the existing mutex, but there were calls with the already holding
the mutex.  Since the only place that needs the extra lock is the code
path from snd_mixart_send_msg(), remove the mutex lock in get_msg()
and apply in the caller side for fixing the mutex deadlock.

Fixes: 8d3a8b5cb57d ("ALSA: mixart: Use nonatomic PCM ops")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201119121440.18945-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/mixart/mixart_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/sound/pci/mixart/mixart_core.c
+++ b/sound/pci/mixart/mixart_core.c
@@ -83,7 +83,6 @@ static int get_msg(struct mixart_mgr *mg
 	unsigned int i;
 #endif
 
-	mutex_lock(&mgr->msg_lock);
 	err = 0;
 
 	/* copy message descriptor from miXart to driver */
@@ -132,8 +131,6 @@ static int get_msg(struct mixart_mgr *mg
 	writel_be(headptr, MIXART_MEM(mgr, MSG_OUTBOUND_FREE_HEAD));
 
  _clean_exit:
-	mutex_unlock(&mgr->msg_lock);
-
 	return err;
 }
 
@@ -271,7 +268,9 @@ int snd_mixart_send_msg(struct mixart_mg
 	resp.data = resp_data;
 	resp.size = max_resp_size;
 
+	mutex_lock(&mgr->msg_lock);
 	err = get_msg(mgr, &resp, msg_frame);
+	mutex_unlock(&mgr->msg_lock);
 
 	if( request->message_id != resp.message_id )
 		dev_err(&mgr->pci->dev, "RESPONSE ERROR!\n");


