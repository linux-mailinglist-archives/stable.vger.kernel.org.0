Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50554126B81
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbfLSS5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730847AbfLSS4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D932624684;
        Thu, 19 Dec 2019 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781798;
        bh=AS6wJQWRcUrr/XYiBzTLgIYCQuq2dVk5CsAwC9pgx+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q67NzVKf3Kg0c8BO3RCE0JfPp8MN+i9UxZGR0Fz0zqxmdDb4mmCDJzGCyHF/Ipmid
         KeQ+KOyFaSzu2GZJ/6uR/Mwu/QN90XDH0ZxYWYFdUxyLk+/CtF1wSrCZuGzF+LJWur
         8uUw6FstMnS3cQFzVIMNL2WAZd3ik4t7Udfn1/Hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Gao Fred <fred.gao@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 5.4 78/80] drm/i915/gvt: Fix cmd length check for MI_ATOMIC
Date:   Thu, 19 Dec 2019 19:35:10 +0100
Message-Id: <20191219183147.737569155@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 92b1aa773fadb4e2a90ed5d3beecb422d568ad9a upstream.

Correct valid command length check for MI_ATOMIC, need to check inline
data available field instead of operand data length for whole command.

Fixes: 00a33be40634 ("drm/i915/gvt: Add valid length check for MI variable commands")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Gao Fred <fred.gao@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/cmd_parser.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -1597,9 +1597,9 @@ static int cmd_handler_mi_op_2f(struct p
 	if (!(cmd_val(s, 0) & (1 << 22)))
 		return ret;
 
-	/* check if QWORD */
-	if (DWORD_FIELD(0, 20, 19) == 1)
-		valid_len += 8;
+	/* check inline data */
+	if (cmd_val(s, 0) & BIT(18))
+		valid_len = CMD_LEN(9);
 	ret = gvt_check_valid_cmd_length(cmd_length(s),
 			valid_len);
 	if (ret)


