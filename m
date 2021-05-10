Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A425E378940
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbhEJL0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237992AbhEJLQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC1E361466;
        Mon, 10 May 2021 11:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645115;
        bh=1Py9AC84fZSZ852glHoxKXuPrgezpssZMNhLsw5PGPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ues1f8ufrLI0ptxaRNP8EoYtI+sjf3DJGInL90B1pkws0dAtXW0ArBE0CM1XvLcN+
         C0+D2HJBU//yyjR4KHpDdSCaIluy0OcZtcLEK6n+DdojTD3fMD9LMNiHjBEcY5VYb3
         jph3WrHgogNa04Dj7D00OJ4sD1vUK7tDTssmAMdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 358/384] media: venus: hfi_parser: Check for instance after hfi platform get
Date:   Mon, 10 May 2021 12:22:27 +0200
Message-Id: <20210510102026.557828201@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

commit 9b5d8fd580caa898c6e1b8605c774f2517f786ab upstream.

The inst function argument is != NULL only for Venus v1 and
we did not migrate v1 to a hfi_platform abstraction yet. So
check for instance != NULL only after hfi_platform_get returns
no error.

Fixes: e29929266be1 ("media: venus: Get codecs and capabilities from hfi platform")
Cc: stable@vger.kernel.org # v5.12
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -235,13 +235,13 @@ static int hfi_platform_parser(struct ve
 	u32 enc_codecs, dec_codecs, count = 0;
 	unsigned int entries;
 
-	if (inst)
-		return 0;
-
 	plat = hfi_platform_get(core->res->hfi_version);
 	if (!plat)
 		return -EINVAL;
 
+	if (inst)
+		return 0;
+
 	if (plat->codecs)
 		plat->codecs(&enc_codecs, &dec_codecs, &count);
 


