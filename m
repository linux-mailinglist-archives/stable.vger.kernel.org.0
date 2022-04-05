Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011AA4F2A15
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242497AbiDEJhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbiDEJCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:02:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE203DF82;
        Tue,  5 Apr 2022 01:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A4AE609D0;
        Tue,  5 Apr 2022 08:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAF9C385A0;
        Tue,  5 Apr 2022 08:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148851;
        bh=hivumiYj3Vdez4XqYK2ou4xLfloLyBkHYVMfL/efwgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhXMlL/fuCFK6BSVImSn393nejQP8Xk92Fp62Q+quAIamvTQzZRv3NwFP4zwBeoMj
         L1iscyz2v0EhVkRD9fIu9wf+maXhMKoGhhUvKeTjZBzEz6RF0GPO72YCE1II48fcli
         U5vnal3MZSEgaJqWITrLuvmHSBqCNgVJODt6CPaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0503/1017] libbpf: Fix memleak in libbpf_netlink_recv()
Date:   Tue,  5 Apr 2022 09:23:36 +0200
Message-Id: <20220405070409.229958390@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 1b8c924a05934d2e758ec7da7bd217ef8ebd80ce ]

Ensure that libbpf_netlink_recv() frees dynamically allocated buffer in
all code paths.

Fixes: 9c3de619e13e ("libbpf: Use dynamically allocated buffer when receiving netlink messages")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/20220217073958.276959-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/netlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 69b353d55dbf..fadde7d80a51 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -176,7 +176,8 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 				libbpf_nla_dump_errormsg(nh);
 				goto done;
 			case NLMSG_DONE:
-				return 0;
+				ret = 0;
+				goto done;
 			default:
 				break;
 			}
@@ -188,9 +189,10 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 				case NL_NEXT:
 					goto start;
 				case NL_DONE:
-					return 0;
+					ret = 0;
+					goto done;
 				default:
-					return ret;
+					goto done;
 				}
 			}
 		}
-- 
2.34.1



