Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7009B35C041
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbhDLJMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238951AbhDLJHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DC0F61354;
        Mon, 12 Apr 2021 09:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218218;
        bh=2WZkXOt956qtWOlf8pzkbON2qStVVDV7YsrnMCDXkwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdBoF+FUw4kAG/RVZfyQ+i01Wri/QZ6hP5Vq26/HJBoxjvVQlPHqObGfFrDVzxFg1
         xoqCqxPzqYwa0Ez8TXnGhlPojkZ5j6vQigKxJiHzDUtN3RgV3vlV3sgZ3lxh1WsIYl
         BSyEaXrWRYwBz+PpKXPRl3FYVnoFhWSPRl87EsUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Ciosek <norbertx.ciosek@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 115/210] virtchnl: Fix layout of RSS structures
Date:   Mon, 12 Apr 2021 10:40:20 +0200
Message-Id: <20210412084019.834459327@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Ciosek <norbertx.ciosek@intel.com>

[ Upstream commit 22f8b5df881e9f1302514bbbbbb8649c2051de55 ]

Remove padding from RSS structures. Previous layout
could lead to unwanted compiler optimizations
in loops when iterating over key and lut arrays.

Fixes: 65ece6de0114 ("virtchnl: Add missing explicit padding to structures")
Signed-off-by: Norbert Ciosek <norbertx.ciosek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/avf/virtchnl.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 40bad71865ea..532bcbfc4716 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -476,7 +476,6 @@ struct virtchnl_rss_key {
 	u16 vsi_id;
 	u16 key_len;
 	u8 key[1];         /* RSS hash key, packed bytes */
-	u8 pad[1];
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_key);
@@ -485,7 +484,6 @@ struct virtchnl_rss_lut {
 	u16 vsi_id;
 	u16 lut_entries;
 	u8 lut[1];        /* RSS lookup table */
-	u8 pad[1];
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_lut);
-- 
2.30.2



