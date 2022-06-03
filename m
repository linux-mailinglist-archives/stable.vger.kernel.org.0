Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE8D53CF6B
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345721AbiFCRyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347262AbiFCRwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF16E3F;
        Fri,  3 Jun 2022 10:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F326B82189;
        Fri,  3 Jun 2022 17:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C88C385A9;
        Fri,  3 Jun 2022 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278704;
        bh=r/EVGuixxhLyn4hbt87fKDBBAPp8TGSvK5WszfHhZ5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itooazSEeiYbbUDMiRc5f0WingTZUOTxIfSuk8nCAwVDF3QFz6nALfi6+pGbopemd
         nsu+1rddJhplQwvmtLA8qPYQ3OR6qJREV/83xXrxeDCY/GC8weZzyln6UBfFjf21Aa
         MK0Wuf+G6pqmt9/oCj7Ekiwxr8YTEc4KaEvwth0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 65/66] bpf: Reject writes for PTR_TO_MAP_KEY in check_helper_mem_access
Date:   Fri,  3 Jun 2022 19:43:45 +0200
Message-Id: <20220603173822.532138272@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 7b3552d3f9f6897851fc453b5131a967167e43c2 upstream.

It is not permitted to write to PTR_TO_MAP_KEY, but the current code in
check_helper_mem_access would allow for it, reject this case as well, as
helpers taking ARG_PTR_TO_UNINIT_MEM also take PTR_TO_MAP_KEY.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20220319080827.73251-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4587,6 +4587,11 @@ static int check_helper_mem_access(struc
 		return check_packet_access(env, regno, reg->off, access_size,
 					   zero_size_allowed);
 	case PTR_TO_MAP_KEY:
+		if (meta && meta->raw_mode) {
+			verbose(env, "R%d cannot write into %s\n", regno,
+				reg_type_str(env, reg->type));
+			return -EACCES;
+		}
 		return check_mem_region_access(env, regno, reg->off, access_size,
 					       reg->map_ptr->key_size, false);
 	case PTR_TO_MAP_VALUE:


