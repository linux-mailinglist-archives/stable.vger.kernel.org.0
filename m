Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4C831BD13
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhBOPjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:39:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231447AbhBOPhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E7564E9C;
        Mon, 15 Feb 2021 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403181;
        bh=445vZ5zW4I0yy7T50vlJ3nojO8A1VZq1mfyxJfDoIY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4ErpDO4859bbCzT9xGpL9HX7RfF5QPaVmH2FpAiVAPPl+oZ7IdRZK9jhSXi7z9N2
         JlHzn5NOH1EZ3mndrW9HN48nGdPkjz+pr3z9IyZ+mdsjsIxaBUi1lebLhHnX7setx/
         Tyk4Vl2oe12dwXC6lePvGgib6JAlqGIvVkuL9wBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Fabian Frederick <fabf@skynet.be>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/104] selftests: netfilter: fix current year
Date:   Mon, 15 Feb 2021 16:27:11 +0100
Message-Id: <20210215152721.353681876@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

[ Upstream commit a3005b0f83f217c888393c6bf9cd36e3d1616bca ]

use date %Y instead of %G to read current year
Problem appeared when running lkp-tests on 01/01/2021

Fixes: 48d072c4e8cd ("selftests: netfilter: add time counter check")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 087f0e6e71ce7..f33154c04d344 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -23,7 +23,7 @@ ip -net "$ns0" addr add 127.0.0.1 dev lo
 
 trap cleanup EXIT
 
-currentyear=$(date +%G)
+currentyear=$(date +%Y)
 lastyear=$((currentyear-1))
 ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table inet filter {
-- 
2.27.0



