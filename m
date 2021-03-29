Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F55034C6DE
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhC2IKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhC2IJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EE0961932;
        Mon, 29 Mar 2021 08:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005383;
        bh=skYx5TgqMEyPtjqOZvtQZwPYnA7TximPdWgLdghkIe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0FszjhMkC7mGAfBgixbchF6QYdZQ0e3jmljTv1ej9U+NCEKrN7bY/IdIil8otXFe
         q3oLoM+s+Xk3PDo7odqNM55mMDKQTSTOXC7+/BjLGkJWJWF1dm3HXneQMQIXqobGpw
         CCWFbZ47JTEx+jhRncpfsMbFG0QKb2M3sGcQBqKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 4.19 61/72] dm verity: add root hash pkcs#7 signature verification
Date:   Mon, 29 Mar 2021 09:58:37 +0200
Message-Id: <20210329075612.300337755@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: JeongHyeon Lee <jhs2.lee@samsung.com>

[ Upstream commit 88cd3e6cfac915f50f7aa7b699bdf053afec866e ]

The verification is to support cases where the root hash is not secured
by Trusted Boot, UEFI Secureboot or similar technologies.

One of the use cases for this is for dm-verity volumes mounted after
boot, the root hash provided during the creation of the dm-verity volume
has to be secure and thus in-kernel validation implemented here will be
used before we trust the root hash and allow the block device to be
created.

The signature being provided for verification must verify the root hash
and must be trusted by the builtin keyring for verification to succeed.

The hash is added as a key of type "user" and the description is passed
to the kernel so it can look it up and use it for verification.

Adds CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG which can be turned on if root
hash verification is needed.

Kernel commandline dm_verity module parameter 'require_signatures' will
indicate whether to force root hash signature verification (for all dm
verity volumes).

Signed-off-by: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Tested-and-Reviewed-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 599be2d2b0ae..fa8c201fca77 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -34,7 +34,7 @@
 #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
 #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
 
-#define DM_VERITY_OPTS_MAX		(2 + DM_VERITY_OPTS_FEC)
+#define DM_VERITY_OPTS_MAX		(3 + DM_VERITY_OPTS_FEC)
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
-- 
2.30.1



