Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E440639A71D
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhFCRKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231634AbhFCRKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B748613F9;
        Thu,  3 Jun 2021 17:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740101;
        bh=lDJasciMIJ4kUC2iSKpOUQaJiHocFiXXunKgoV9fq7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jj6mEsL4JeUCrt/Cw6FO/NEspu166VUFdyE0iZ9cjOjJCfbZ0saGbWWg9dQ8KH9v6
         gtycNXwIbR7kTO+1SZDsejv3f8v3gmcwr6RF4zyZg0grKmWBm81NcKtB4DSqJU9Ezl
         +IsweGFOm4fWmcJTiAE3ByAKj1ANVKwJ3VujRq3U3O73baFZLdn1EsOHguqd9odGT0
         BToQDzb5F+2wtCTCbtRJTdc+n+v4mi27d25fAuE26GA2wOp5rtVRv3kA4DctjpU7rO
         ne0Bc28wZr63RYO886Ain/A5nkvQZF9wPiqg/7ZlPVooHm+ev6RWc258whRZSrH/ah
         jiRJ6Nqd+DprQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Keeping <john@metanate.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 38/43] dm verity: fix require_signatures module_param permissions
Date:   Thu,  3 Jun 2021 13:07:28 -0400
Message-Id: <20210603170734.3168284-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

[ Upstream commit 0c1f3193b1cdd21e7182f97dc9bca7d284d18a15 ]

The third parameter of module_param() is permissions for the sysfs node
but it looks like it is being used as the initial value of the parameter
here.  In fact, false here equates to omitting the file from sysfs and
does not affect the value of require_signatures.

Making the parameter writable is not simple because going from
false->true is fine but it should not be possible to remove the
requirement to verify a signature.  But it can be useful to inspect the
value of this parameter from userspace, so change the permissions to
make a read-only file in sysfs.

Signed-off-by: John Keeping <john@metanate.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-verify-sig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index 29385dc470d5..db61a1f43ae9 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -15,7 +15,7 @@
 #define DM_VERITY_VERIFY_ERR(s) DM_VERITY_ROOT_HASH_VERIFICATION " " s
 
 static bool require_signatures;
-module_param(require_signatures, bool, false);
+module_param(require_signatures, bool, 0444);
 MODULE_PARM_DESC(require_signatures,
 		"Verify the roothash of dm-verity hash tree");
 
-- 
2.30.2

