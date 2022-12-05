Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2419E643386
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbiLEThD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiLETgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3740927920
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C96E761315
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDBCC433C1;
        Mon,  5 Dec 2022 19:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268824;
        bh=JbmSiZfEvEMXgZ51+paGM32Fv0h0ir9/7bQdN1CIYAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdhV79cwHi8dyazn3mlCq8SaqwDZYb5COmIIIim6NFWr4iU1pf8I68QF9rhYe4ie7
         J2vStUMr87zI21pJuZZkVG7uWvJiOF5f1g6fQBXfIMb68v2kJm/ZT83AIDsOamAzgO
         5igPQrnVcF30mItUyRaDEo59zhWiZkuverpw+js8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/120] bpf: Do not copy spin lock field from user in bpf_selem_alloc
Date:   Mon,  5 Dec 2022 20:09:25 +0100
Message-Id: <20221205190807.327595947@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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
index de4d741d99a3..6c2d39a3d558 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -71,7 +71,7 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, void *owner,
 				GFP_ATOMIC | __GFP_NOWARN);
 	if (selem) {
 		if (value)
-			memcpy(SDATA(selem)->data, value, smap->map.value_size);
+			copy_map_value(&smap->map, SDATA(selem)->data, value);
 		return selem;
 	}
 
-- 
2.35.1



