Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEC01C442B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731722AbgEDSEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731124AbgEDSEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:04:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 644C4207DD;
        Mon,  4 May 2020 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615488;
        bh=G65lQelbqc4i5B5KqVbnSIKD0TuyLLjRWtqcJAfC5cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNANzQCtpCuMzRvVER2q83TWaSk7KeV1cH8Z33cpIgsGPaFV3I0vD8mWz1o7PBdFF
         b4gSgfrImx1WuS8BVLgp4mhcPCCKeDZA+Ookom8TUvruQ9vN0QzinS08rqYrKEfndt
         18g40OHLN2kGJzd/0f4sFK+eEo299a63WKPyCNN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunwook Eom <speed.eom@samsung.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 30/57] dm verity fec: fix hash block number in verity_fec_decode
Date:   Mon,  4 May 2020 19:57:34 +0200
Message-Id: <20200504165458.958492332@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
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
@@ -435,7 +435,7 @@ int verity_fec_decode(struct dm_verity *
 	fio->level++;
 
 	if (type == DM_VERITY_BLOCK_TYPE_METADATA)
-		block += v->data_blocks;
+		block = block - v->hash_start + v->data_blocks;
 
 	/*
 	 * For RS(M, N), the continuous FEC data is divided into blocks of N


