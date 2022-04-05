Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692BC4F28E5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbiDEIXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbiDEIRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC15B2452;
        Tue,  5 Apr 2022 01:05:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3584B81B7F;
        Tue,  5 Apr 2022 08:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA1EC385A0;
        Tue,  5 Apr 2022 08:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145950;
        bh=hivumiYj3Vdez4XqYK2ou4xLfloLyBkHYVMfL/efwgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJkobjcrtL8Z9PCZA8dX0z+YyZ5pYz5f//Ja7O+xztP3DpiM34kWmSH/UcNldJicq
         6se3Hcp3T7v0WYpw0PVJBU3IHFOz789aAU6vp5mO9GBbuSD63gfMtllA3pyqGeeH4Y
         2LVP1Hyo83Jefws9537rV/jTH0I/GEoAuu/Gx8ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0551/1126] libbpf: Fix memleak in libbpf_netlink_recv()
Date:   Tue,  5 Apr 2022 09:21:38 +0200
Message-Id: <20220405070423.806054703@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



