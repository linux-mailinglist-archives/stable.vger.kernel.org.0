Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B7E1C438D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgEDR7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730767AbgEDR7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ADC220746;
        Mon,  4 May 2020 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615162;
        bh=oj1aSHJQB2KRe6kNlCB/UO6RMr8tKwXPStULUd2W+Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPtF2xBK+qFHYtRzxZTDLfo50NSZjAprOqFxvAWeWp/ktfTCnH9d8gkBfzrxrGg08
         kCKHvk31JwC5VXNigEv8vmPpViKOmTLyen8Ocv0rXwxUEhY0GbDuXaAyKuy86lrkpz
         d0O2Rt9FB6kKb3Nxx571fvqoxMvWOuMm4y26C8Mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunwook Eom <speed.eom@samsung.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 10/18] dm verity fec: fix hash block number in verity_fec_decode
Date:   Mon,  4 May 2020 19:57:20 +0200
Message-Id: <20200504165444.248614958@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.028485341@linuxfoundation.org>
References: <20200504165442.028485341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunwook Eom <speed.eom@samsung.com>

commit ad4e80a639fc61d5ecebb03caa5cdbfb91fcebfc upstream.

The error correction data is computed as if data and hash blocks
were concatenated. But hash block number starts from v->hash_start.
So, we have to calculate hash block number based on that.

Fixes: a739ff3f543af ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Sunwook Eom <speed.eom@samsung.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-verity-fec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -447,7 +447,7 @@ int verity_fec_decode(struct dm_verity *
 	fio->level++;
 
 	if (type == DM_VERITY_BLOCK_TYPE_METADATA)
-		block += v->data_blocks;
+		block = block - v->hash_start + v->data_blocks;
 
 	/*
 	 * For RS(M, N), the continuous FEC data is divided into blocks of N


