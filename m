Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EABF6948F6
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjBMOzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjBMOyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5409A27A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78032B81250
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B67C433EF;
        Mon, 13 Feb 2023 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300083;
        bh=AxAluxM/BK+fXKw04pUKix1NYp6feId1wrRaWhDTZB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JvP05n6RZdSWxafHN6ooy3l7hsOZCxfD/dijXKwxXhK/oF2AQ12rXXd4lIuFlMYH
         4Bd18/GfzeuzUF7bvBSiZuuLQazlKl6boWE+ODPHcM4LTe+9SV54oWtmnBfOYIhTEG
         8JQ4fX2zMWnFJGCMIbmvDdibRgSgK+f6frhfFH8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/114] selftests: Fix failing VXLAN VNI filtering test
Date:   Mon, 13 Feb 2023 15:48:12 +0100
Message-Id: <20230213144745.171076697@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit b963d9d5b9437a6b99504987310f98537c9e77d4 ]

iproute2 does not recognize the "group6" and "remote6" keywords. Fix by
using "group" and "remote" instead.

Before:

 # ./test_vxlan_vnifiltering.sh
 [...]
 Tests passed:  25
 Tests failed:   2

After:

 # ./test_vxlan_vnifiltering.sh
 [...]
 Tests passed:  27
 Tests failed:   0

Fixes: 3edf5f66c12a ("selftests: add new tests for vxlan vnifiltering")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20230207141819.256689-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/test_vxlan_vnifiltering.sh   | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
index 704997ffc2449..8c3ac0a725451 100755
--- a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
+++ b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
@@ -293,19 +293,11 @@ setup-vm() {
 	elif [[ -n $vtype && $vtype == "vnifilterg" ]]; then
 	   # Add per vni group config with 'bridge vni' api
 	   if [ -n "$group" ]; then
-	      if [ "$family" == "v4" ]; then
-		 if [ $mcast -eq 1 ]; then
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
-		 else
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
-		 fi
-	      else
-		 if [ $mcast -eq 1 ]; then
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group6 $group
-		 else
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote6 $group
-		 fi
-	      fi
+		if [ $mcast -eq 1 ]; then
+			bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
+		else
+			bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
+		fi
 	   fi
 	fi
 	done
-- 
2.39.0



