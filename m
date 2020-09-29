Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F2D27CCF6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgI2Mkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729350AbgI2LOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E98D206A5;
        Tue, 29 Sep 2020 11:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378078;
        bh=JYuoka6Dcpa7rPPX+K0pgm8y9LHlMras/8gA7lLYGAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNEMnAB6EBSUTT7JIcYwcG7XWXtrozGm8OF3cS2cUC18GonasrzDiuuJA3fu2nOFU
         ib+s3xTv3vlVeYt3WWw6EnqTrCg1IaLzrhlBGyth+L43uChNZ3RJ7s5xXnU1UYWuNX
         3XvrU3e16DWR5tiyrski/TVo8CMgkMIlT1mVx8ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/166] selftests/ftrace: fix glob selftest
Date:   Tue, 29 Sep 2020 12:59:24 +0200
Message-Id: <20200929105937.804658082@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit af4ddd607dff7aabd466a4a878e01b9f592a75ab ]

test.d/ftrace/func-filter-glob.tc is failing on s390 because it has
ARCH_INLINE_SPIN_LOCK and friends set to 'y'. So the usual
__raw_spin_lock symbol isn't in the ftrace function list. Change
'*aw*lock' to '*spin*lock' which would hopefully match some of the
locking functions on all platforms.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
index 27a54a17da65d..f4e92afab14b2 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc
@@ -30,7 +30,7 @@ ftrace_filter_check '*schedule*' '^.*schedule.*$'
 ftrace_filter_check 'schedule*' '^schedule.*$'
 
 # filter by *mid*end
-ftrace_filter_check '*aw*lock' '.*aw.*lock$'
+ftrace_filter_check '*pin*lock' '.*pin.*lock$'
 
 # filter by start*mid*
 ftrace_filter_check 'mutex*try*' '^mutex.*try.*'
-- 
2.25.1



