Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA3148924B
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiAJHlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241463AbiAJHhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:37:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79368C028B9B;
        Sun,  9 Jan 2022 23:32:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 377BDB81204;
        Mon, 10 Jan 2022 07:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CFDC36AEF;
        Mon, 10 Jan 2022 07:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799945;
        bh=8Wk2NLB4bR+9xiQiR7OKCh9kPDKCq8X83GEBI/7BFq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcOZftIT/n1ni5Rt+1sGX4mtjQ/WDO1Am60i2n5nVCvn1fxYwLt+D68MUCFOxV5Ku
         DPMFVXQZTU42AohW6kKOEpOkQLxiUaVKq4F0YVV8aXWaJPtAxZ5WeAT1mtm5VoyqRb
         dj9eEhplRBorScRnt2mlhsnSX6um5CcPUKPj83MI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 25/72] selftests: net: udpgro_fwd.sh: explicitly checking the available ping feature
Date:   Mon, 10 Jan 2022 08:23:02 +0100
Message-Id: <20220110071822.418727887@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

commit 5e75d0b215b868337e7a193f28a543ec00e858b1 upstream.

As Paolo pointed out, the result of ping IPv6 address depends on
the running distro. So explicitly checking the available ping feature,
as e.g. do the bareudp.sh self-tests.

Fixes: 8b3170e07539 ("selftests: net: using ping6 for IPv6 in udpgro_fwd.sh")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Link: https://lore.kernel.org/r/825ee22b-4245-dbf7-d2f7-a230770d6e21@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/udpgro_fwd.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -193,7 +193,8 @@ for family in 4 6; do
 		SUFFIX="64 nodad"
 		VXDEV=vxlan6
 		IPT=ip6tables
-		PING="ping6"
+		# Use ping6 on systems where ping doesn't handle IPv6
+		ping -w 1 -c 1 ::1 > /dev/null 2>&1 || PING="ping6"
 	fi
 
 	echo "IPv$family"


