Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4EA5A8A19
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 02:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiIAA4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 20:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiIAA4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 20:56:40 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B42CE32B
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 17:56:38 -0700 (PDT)
X-UUID: 3865d0b3b61949b89ce7990c3f17a53e-20220901
X-CPASD-INFO: e6f4fdb779114f67ab104e436bead177@roagVJOWkGdjWXN9g6mBcYGTYWBkkVS
        CeJyFkZJhY1eVhH5xTV5uYFV9fWtVYV9dYVR6eGxQYmBgZFJ4i3-XblBgXoZgUZB3tHigVJaSkg==
X-CLOUD-ID: e6f4fdb779114f67ab104e436bead177
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:196.
        0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:313.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:4480.0,FROMTO:1,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-
        5,AUF:1,DUF:3711,ACD:66,DCD:66,SL:0,EISP:0,AG:0,CFC:0.442,CFSR:0.045,UAT:0,RA
        F:0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,E
        AF:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 3865d0b3b61949b89ce7990c3f17a53e-20220901
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: 3865d0b3b61949b89ce7990c3f17a53e-20220901
X-User: chenzhang@kylinos.cn
Received: from localhost.localdomain [(112.64.161.44)] by mailgw
        (envelope-from <chenzhang@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 2136868779; Thu, 01 Sep 2022 08:56:55 +0800
From:   chen zhang <chenzhang@kylinos.cn>
To:     chenzhang@kylinos.cn
Cc:     chenzhang_0901@163.com, Paolo Valerio <pvalerio@redhat.com>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] openvswitch: fix OOB access in reserve_sfa_size()
Date:   Thu,  1 Sep 2022 08:56:30 +0800
Message-Id: <20220901005630.48577-1-chenzhang@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valerio <pvalerio@redhat.com>

Mainline: cefa91b2332d7009bc0be5d951d6cbbf349f90f8
From: v5.18-rc4
Severity: Low

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
Signed-off-by: chen zhang <chenzhang@kylinos.cn>
Change-Id: Ida20ea8a448b3641df21661983a0b730c3c12e14
---
 net/openvswitch/flow_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index c591b923016a..d77c21ff066c 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2436,7 +2436,7 @@ static struct nlattr *reserve_sfa_size(struct sw_flow_actions **sfa,
 	new_acts_size = max(next_offset + req_size, ksize(*sfa) * 2);
 
 	if (new_acts_size > MAX_ACTIONS_BUFSIZE) {
-		if ((MAX_ACTIONS_BUFSIZE - next_offset) < req_size) {
+		if ((next_offset + req_size) > MAX_ACTIONS_BUFSIZE) {
 			OVS_NLERR(log, "Flow action size exceeds max %u",
 				  MAX_ACTIONS_BUFSIZE);
 			return ERR_PTR(-EMSGSIZE);
-- 
2.25.1

