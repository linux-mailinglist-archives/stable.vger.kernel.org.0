Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8DF4124CD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347147AbhITSiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379711AbhITSgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 095BF63312;
        Mon, 20 Sep 2021 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158948;
        bh=6Ta2N8n3Fgd+Rq1jJt28IfFGML1jBiYnkTE+JV4HOss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCSxcUoEW8+eskW7WRFOsU1kTsltZ/sHwFmJB9iNIy6SL76pI0fASX5PORGO+OR3e
         ZxvKUpqOwbZcZZjiEikDpRh+YCm3Kai6PHPArL2DD06xskUmPVt3MW1tVqiaD5Fk19
         d+jaIExkbiu5eERuQzUqWRa9Yaxftzf5Q0H5ujYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/122] selftests: mptcp: clean tmp files in simult_flows
Date:   Mon, 20 Sep 2021 18:44:35 +0200
Message-Id: <20210920163919.171097841@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit bfd862a7e9318dd906844807a713d27cdd1a72b1 ]

'$cin' and '$sin' variables are local to a function: they are then not
available from the cleanup trap.

Instead, we need to use '$large' and '$small' that are not local and
defined just before setting the trap.

Without this patch, running this script in a loop might cause a:

  write: No space left on device

issue.

Fixes: 1a418cb8e888 ("mptcp: simult flow self-tests")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 2f649b431456..8fcb28927818 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -21,8 +21,8 @@ usage() {
 
 cleanup()
 {
-	rm -f "$cin" "$cout"
-	rm -f "$sin" "$sout"
+	rm -f "$cout" "$sout"
+	rm -f "$large" "$small"
 	rm -f "$capout"
 
 	local netns
-- 
2.30.2



