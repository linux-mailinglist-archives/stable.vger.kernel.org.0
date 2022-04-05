Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDF54F37A1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359409AbiDELSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349114AbiDEJtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9035AA027;
        Tue,  5 Apr 2022 02:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68097B81B14;
        Tue,  5 Apr 2022 09:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65DCC385A2;
        Tue,  5 Apr 2022 09:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151662;
        bh=hivumiYj3Vdez4XqYK2ou4xLfloLyBkHYVMfL/efwgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kkfDhFwQUR8wzKfv+UB7pxmrSYkY7bu2GOAZNLpDNV2yhI7+y7LpE81DnzYHsPKW
         m8CrreNwmd/SZq6ZlGQ+WjHdw1dyBOwWCUADHsD7GNjUjPTNmMtWvrQUZsv7VuDavD
         Aqh/4ktH1HLqOEaud0bjtiuhHxSerTK4ykSs0Odw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 458/913] libbpf: Fix memleak in libbpf_netlink_recv()
Date:   Tue,  5 Apr 2022 09:25:20 +0200
Message-Id: <20220405070353.577613382@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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



