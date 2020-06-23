Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E415E20663A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388567AbgFWVjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388573AbgFWUHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9FF12064B;
        Tue, 23 Jun 2020 20:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942829;
        bh=QP6tJUUtGHfRPksj92wCUrbYb57oWUe1ma4dltobteE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E13t2jkpKUJQ1W2wiMbtrRBzuCzqJwACtlJp3h4sG98KWwvc3Q4PEkdVedbUqVriL
         tDHoRatthQYyq1+pfa6VSWM0WaNx8QKBV8nL1zYXMMAzsU+UwoZtnKatfF5nhO5W4c
         s+Awh+4nYt5Ph4lfNtK7XMeLhS1WMRsbiY2/3C2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 152/477] ASoC: component: suppress uninitialized-variable warning
Date:   Tue, 23 Jun 2020 21:52:29 +0200
Message-Id: <20200623195414.778521596@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit be16a0f0dc8fab8e25d9cdbeb4f8f28afc9186d2 ]

Old versions of gcc (tested on gcc-4.8) produce a warning for
correct code:

sound/soc/soc-compress.c: In function 'soc_compr_open':
sound/soc/soc-compress.c:75:28: error: 'component' is used uninitialized in this function [-Werror=uninitialized]
  struct snd_soc_component *component, *save = NULL;

Change the for_each_rtd_components() macro to ensure 'component'
gets initialized to a value the compiler does not complain about.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200428214754.3925368-1-arnd@arndb.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 946f88a6c63d1..e0371e70242d5 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1177,7 +1177,7 @@ struct snd_soc_pcm_runtime {
 #define asoc_rtd_to_codec(rtd, n) (rtd)->dais[n + (rtd)->num_cpus]
 
 #define for_each_rtd_components(rtd, i, component)			\
-	for ((i) = 0;							\
+	for ((i) = 0, component = NULL;					\
 	     ((i) < rtd->num_components) && ((component) = rtd->components[i]);\
 	     (i)++)
 #define for_each_rtd_cpu_dais(rtd, i, dai)				\
-- 
2.25.1



