Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111FE3A6281
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbhFNLBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234901AbhFNK73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6ADC6161F;
        Mon, 14 Jun 2021 10:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667350;
        bh=VHAXdjdcllNCvOk3Jm+KgEHu0Sx0iGudak86gchl8V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAScReXIgh2j9R+lu0Ok3ZH/M9glNf9GP2vYZVqf4YFn1EL2Ihh0hBbzZ0+AQd0AM
         Mnbib1i4iqA6HA3YOoilceqz4QF7bovvMnzYab8rH43CvAF3VFSoAAsnfuc3V/vY4g
         cbmmttEm8dySFV8+Uku9xM6aPbITUWxM7KiVzVRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/131] dm verity: fix require_signatures module_param permissions
Date:   Mon, 14 Jun 2021 12:26:36 +0200
Message-Id: <20210614102654.198616176@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
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
index 614e43db93aa..919154ae4cae 100644
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



