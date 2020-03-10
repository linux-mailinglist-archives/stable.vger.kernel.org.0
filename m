Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402F117FCA9
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgCJNBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbgCJNBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:01:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AAF42467D;
        Tue, 10 Mar 2020 13:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845292;
        bh=VVjIXwPkrqnR2wi6ZaS3kd0ZA5iuH5URV97l+aRyis4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDID5TClsf/n69UxpmHb2ZS1eUCFM0/OgqpQ96naGR/qtUT7QIvWfzjePKl5w5BtQ
         01PYgRde88h7dZvpyXHV+LkEBSyi9/CTO7P7i9TGcH/JWWruI2VX9HS7KFgTMlezs1
         if6WthS2wX+gkzsTETzjGRToXz7nQqRhajlkRYbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 132/189] ASoC: SOF: Fix snd_sof_ipc_stream_posn()
Date:   Tue, 10 Mar 2020 13:39:29 +0100
Message-Id: <20200310123653.159130273@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 613cea5935e83cb5a7d182ee3f98d54620e102e2 upstream.

We're passing "&posn" instead of "posn" so it ends up corrupting
memory instead of doing something useful.

Fixes: 53e0c72d98ba ("ASoC: SOF: Add support for IPC IO between DSP and Host")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200303101858.ytehbrivocyp3cnf@kili.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sof/ipc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -495,7 +495,7 @@ int snd_sof_ipc_stream_posn(struct snd_s
 
 	/* send IPC to the DSP */
 	err = sof_ipc_tx_message(sdev->ipc,
-				 stream.hdr.cmd, &stream, sizeof(stream), &posn,
+				 stream.hdr.cmd, &stream, sizeof(stream), posn,
 				 sizeof(*posn));
 	if (err < 0) {
 		dev_err(sdev->dev, "error: failed to get stream %d position\n",


