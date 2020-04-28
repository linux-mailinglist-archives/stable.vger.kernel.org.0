Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454841BC878
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgD1Scz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729861AbgD1Scx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD5992076A;
        Tue, 28 Apr 2020 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098773;
        bh=Au1q+YxF5wXpGR9tG9DyL2Nn00oGiow5jjlqbZMVauA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSGCaMJXb2E5e3/XxKG6oCIGft6ZhIzkiS12w8zvCdI27h3/zSqPNKctrfuAx0TFg
         zwgOP9ydyigVZF+An+LXCs9jr6x/kOU6tXpLO6oLPvRqdkn6knihKGSBTnfxbTrxON
         ab93zFO2p52CVXbhmlLVLKY+fmgDfOe65H4Tn07A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.6 110/167] tpm: fix wrong return value in tpm_pcr_extend
Date:   Tue, 28 Apr 2020 20:24:46 +0200
Message-Id: <20200428182239.092034139@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit 29cb79795e324a8b65e7891d76f8f6ca911ba440 upstream.

For the algorithm that does not match the bank, a positive
value EINVAL is returned here. I think this is a typo error.
It is necessary to return an error value.

Cc: stable@vger.kernel.org # 5.4.x
Fixes: 9f75c8224631 ("KEYS: trusted: correctly initialize digests and fix locking issue")
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm-interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -323,7 +323,7 @@ int tpm_pcr_extend(struct tpm_chip *chip
 
 	for (i = 0; i < chip->nr_allocated_banks; i++) {
 		if (digests[i].alg_id != chip->allocated_banks[i].alg_id) {
-			rc = EINVAL;
+			rc = -EINVAL;
 			goto out;
 		}
 	}


