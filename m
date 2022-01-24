Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24970499552
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392561AbiAXUva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46934 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390829AbiAXUq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D2B5B81257;
        Mon, 24 Jan 2022 20:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E15C36AE3;
        Mon, 24 Jan 2022 20:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057185;
        bh=Optsw7fZH7IyeMM7yyHVhmBMnQlfEE3Lft2i5Il4zVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVQKRVJ/aWBGV1/SBXphIUhuv/55vVb72r/4E/GQGV/ujOPs5x4Y+DuqYMmRwRtso
         YmMLAteqrgz1axRUbiWzB0O1AQkmNy8utLGHU5nKxE/uY7IChyHZvMyhONKdi4FhGy
         7CqN4eXtw5SPxYZkh6/LPaI3DLfO8/BaZnAuFne4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 730/846] of: base: Improve argument length mismatch error
Date:   Mon, 24 Jan 2022 19:44:07 +0100
Message-Id: <20220124184126.181693077@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

commit 5d05b811b5acb92fc581a7b328b36646c86f5ab9 upstream.

The cells_name field of of_phandle_iterator might be NULL. Use the
phandle name instead. With this change instead of:

  OF: /soc/pinctrl@1000000: (null) = 3 found 2

We get:

  OF: /soc/pinctrl@1000000: phandle pinctrl@1000000 needs 3, found 2

Which is a more helpful messages making DT debugging easier.

In this particular example the phandle name looks like duplicate of the
same node name. But note that the first node is the parent node
(it->parent), while the second is the phandle target (it->node). They
happen to be the same in the case that triggered this improvement. See
commit 72cb4c48a46a ("arm64: dts: qcom: ipq6018: Fix gpio-ranges
property").

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/f6a68e0088a552ea9dfd4d8e3b5b586d92594738.1640881913.git.baruch@tkos.co.il
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1327,9 +1327,14 @@ int of_phandle_iterator_next(struct of_p
 		 * property data length
 		 */
 		if (it->cur + count > it->list_end) {
-			pr_err("%pOF: %s = %d found %td\n",
-			       it->parent, it->cells_name,
-			       count, it->list_end - it->cur);
+			if (it->cells_name)
+				pr_err("%pOF: %s = %d found %td\n",
+					it->parent, it->cells_name,
+					count, it->list_end - it->cur);
+			else
+				pr_err("%pOF: phandle %s needs %d, found %td\n",
+					it->parent, of_node_full_name(it->node),
+					count, it->list_end - it->cur);
 			goto err;
 		}
 	}


