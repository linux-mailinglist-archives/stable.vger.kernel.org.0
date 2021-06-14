Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FF03A6383
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhFNLN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234770AbhFNLL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3881261954;
        Mon, 14 Jun 2021 10:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667694;
        bh=lDJasciMIJ4kUC2iSKpOUQaJiHocFiXXunKgoV9fq7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFc9oEA4GpobcLwCwFRFF4OdOHUgB+IBBQckW9SSuqvHnyq9VK/d3s5gOuY1eYV64
         o/NqIUJ0YzMLlojRw3+bzqHiqTZ6i/j6Z8cnF0MSjl9mmbYvxuLXpWOhAmMHAg1G4x
         YRGWdhxxm1CK+CA2HpOIZtNYNI+jaXQFE2x7G/rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 039/173] dm verity: fix require_signatures module_param permissions
Date:   Mon, 14 Jun 2021 12:26:11 +0200
Message-Id: <20210614102659.464772368@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



