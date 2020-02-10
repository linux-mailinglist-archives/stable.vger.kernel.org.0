Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9666F157BFB
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgBJNd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbgBJMfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:31 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA5D24680;
        Mon, 10 Feb 2020 12:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338131;
        bh=LMWAKcbg0eScyIo02ULmwMkLauaeopZa6cWoABht6YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EE8gaINZkkrGvF8Xc94f2f2qfL+xTrVXyy7ThshJQCKE8Ffl9Rl6jp7/d3u4/nAK/
         noTwLscXJDvQt57XkU/SeZgHPHc8w8Nr02mJlBiJdZj1FrfpHP9T8yVAQFUlGlsnod
         0/cGJA1oYFanhWue4OL/I461CccDfiQGtwYHIc98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 075/195] crypto: ccree - fix pm wrongful error reporting
Date:   Mon, 10 Feb 2020 04:32:13 -0800
Message-Id: <20200210122313.051386198@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit cedca59fae5834af8445b403c66c9953754375d7 upstream.

pm_runtime_get_sync() can return 1 as a valid (none error) return
code. Treat it as such.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -82,7 +82,7 @@ int cc_pm_get(struct device *dev)
 	else
 		pm_runtime_get_noresume(dev);
 
-	return rc;
+	return (rc == 1 ? 0 : rc);
 }
 
 int cc_pm_put_suspend(struct device *dev)


