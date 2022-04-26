Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B050450F402
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344858AbiDZIbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344831AbiDZI3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:29:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452496D3A5;
        Tue, 26 Apr 2022 01:24:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4BCBB81CF9;
        Tue, 26 Apr 2022 08:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326A5C385A0;
        Tue, 26 Apr 2022 08:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961483;
        bh=o/IWPVY5ARGqzh4upZ5GQxmhxJmgd9wldiluqkdNIF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNp2UDrgmWnvdgq2+TfW3G0dWLU524sj9d40Fnv6joRob7sClFvyo1cVJQ9F7tdHw
         mV3xK2TnZ/DTF5/XkkzTQoo3Cyfpegcy5dSaH5taNkBRQ/dEsWnlmA03wKkr3Bbi3z
         hlDxtHBmZf0pjOthZlEX0R9MKbpK82yfQSxkvyhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Valerio <pvalerio@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 25/43] openvswitch: fix OOB access in reserve_sfa_size()
Date:   Tue, 26 Apr 2022 10:21:07 +0200
Message-Id: <20220426081735.261088738@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valerio <pvalerio@redhat.com>

commit cefa91b2332d7009bc0be5d951d6cbbf349f90f8 upstream.

Given a sufficiently large number of actions, while copying and
reserving memory for a new action of a new flow, if next_offset is
greater than MAX_ACTIONS_BUFSIZE, the function reserve_sfa_size() does
not return -EMSGSIZE as expected, but it allocates MAX_ACTIONS_BUFSIZE
bytes increasing actions_len by req_size. This can then lead to an OOB
write access, especially when further actions need to be copied.

Fix it by rearranging the flow action size check.

KASAN splat below:

==================================================================
BUG: KASAN: slab-out-of-bounds in reserve_sfa_size+0x1ba/0x380 [openvswitch]
Write of size 65360 at addr ffff888147e4001c by task handler15/836

CPU: 1 PID: 836 Comm: handler15 Not tainted 5.18.0-rc1+ #27
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x45/0x5a
 print_report.cold+0x5e/0x5db
 ? __lock_text_start+0x8/0x8
 ? reserve_sfa_size+0x1ba/0x380 [openvswitch]
 kasan_report+0xb5/0x130
 ? reserve_sfa_size+0x1ba/0x380 [openvswitch]
 kasan_check_range+0xf5/0x1d0
 memcpy+0x39/0x60
 reserve_sfa_size+0x1ba/0x380 [openvswitch]
 __add_action+0x24/0x120 [openvswitch]
 ovs_nla_add_action+0xe/0x20 [openvswitch]
 ovs_ct_copy_action+0x29d/0x1130 [openvswitch]
 ? __kernel_text_address+0xe/0x30
 ? unwind_get_return_address+0x56/0xa0
 ? create_prof_cpu_mask+0x20/0x20
 ? ovs_ct_verify+0xf0/0xf0 [openvswitch]
 ? prep_compound_page+0x198/0x2a0
 ? __kasan_check_byte+0x10/0x40
 ? kasan_unpoison+0x40/0x70
 ? ksize+0x44/0x60
 ? reserve_sfa_size+0x75/0x380 [openvswitch]
 __ovs_nla_copy_actions+0xc26/0x2070 [openvswitch]
 ? __zone_watermark_ok+0x420/0x420
 ? validate_set.constprop.0+0xc90/0xc90 [openvswitch]
 ? __alloc_pages+0x1a9/0x3e0
 ? __alloc_pages_slowpath.constprop.0+0x1da0/0x1da0
 ? unwind_next_frame+0x991/0x1e40
 ? __mod_node_page_state+0x99/0x120
 ? __mod_lruvec_page_state+0x2e3/0x470
 ? __kasan_kmalloc_large+0x90/0xe0
 ovs_nla_copy_actions+0x1b4/0x2c0 [openvswitch]
 ovs_flow_cmd_new+0x3cd/0xb10 [openvswitch]
 ...

Cc: stable@vger.kernel.org
Fixes: f28cd2af22a0 ("openvswitch: fix flow actions reallocation")
Signed-off-by: Paolo Valerio <pvalerio@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/flow_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -1977,7 +1977,7 @@ static struct nlattr *reserve_sfa_size(s
 	new_acts_size = max(next_offset + req_size, ksize(*sfa) * 2);
 
 	if (new_acts_size > MAX_ACTIONS_BUFSIZE) {
-		if ((MAX_ACTIONS_BUFSIZE - next_offset) < req_size) {
+		if ((next_offset + req_size) > MAX_ACTIONS_BUFSIZE) {
 			OVS_NLERR(log, "Flow action size exceeds max %u",
 				  MAX_ACTIONS_BUFSIZE);
 			return ERR_PTR(-EMSGSIZE);


