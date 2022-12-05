Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647A164329D
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbiLET1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiLET0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD0024BEC
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:23:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE795B81200
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C163C433C1;
        Mon,  5 Dec 2022 19:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268224;
        bh=qR3ecGN+bDM1sfIz4tYuS3CGvoUE56QXFPrnFibYKE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEDCntJM51ZEanVtQxXOI70HOFHG2NHOhu0fnkqXHAA45Djc1WGNaZwMmimTRGTyF
         GZ9mn5iFo25NPmUszt6cmtAggnt6tlyhAHESAmbke0M+sXTIPyfCVIAMAmxEIkWGIw
         5df87/NftZu3+N5QSi0T4HPYU8KFJQjHVfu7uMsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 025/124] bpf: Do not copy spin lock field from user in bpf_selem_alloc
Date:   Mon,  5 Dec 2022 20:08:51 +0100
Message-Id: <20221205190809.166658253@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 836e49e103dfeeff670c934b7d563cbd982fce87 ]

bpf_selem_alloc function is used by inode_storage, sk_storage and
task_storage maps to set map value, for these map types, there may
be a spin lock in the map value, so if we use memcpy to copy the whole
map value from user, the spin lock field may be initialized incorrectly.

Since the spin lock field is zeroed by kzalloc, call copy_map_value
instead of memcpy to skip copying the spin lock field to fix it.

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20221114134720.1057939-2-xukuohai@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index d13ffb00e981..cbe918ba9035 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -74,7 +74,7 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, void *owner,
 				gfp_flags | __GFP_NOWARN);
 	if (selem) {
 		if (value)
-			memcpy(SDATA(selem)->data, value, smap->map.value_size);
+			copy_map_value(&smap->map, SDATA(selem)->data, value);
 		return selem;
 	}
 
-- 
2.35.1



