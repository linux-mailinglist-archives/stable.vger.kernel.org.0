Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577636582ED
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbiL1QnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbiL1Qmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:42:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80131FCD9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E617B817F6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C72C433EF;
        Wed, 28 Dec 2022 16:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245404;
        bh=ExFAmNH5mIw0yinUvm0KNakICdbGLYc9L+GW9mv+vhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iWehRM8V+4L9bBe2y9N1vwNQ/V4khlN4toVBbUcHY7/NAqUI1J+yJ3CM+CUzfDBy
         r7nCveXht6XBniT0YCUDFHIlgHw3UCFXQOO8/9PfOt9RZtIvcE+3mhurEZT/3hPCha
         kcozyh22SIVBfRwC7Y9JnIgJ9JG9MlGXlGjlxOjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nayna Jain <nayna@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0853/1146] powerpc/pseries: Return -EIO instead of -EINTR for H_ABORTED error
Date:   Wed, 28 Dec 2022 15:39:52 +0100
Message-Id: <20221228144353.323885928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit bb8e4c7cb759b90a04f2e94056b50288ff46a0ed ]

Some commands for eg. "cat" might continue to retry on encountering
EINTR. This is not expected for original error code H_ABORTED.

Map H_ABORTED to more relevant Linux error code EIO.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-4-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 32ce4d780d8f..cbea447122ca 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -111,7 +111,7 @@ static int pseries_status_to_err(int rc)
 		err = -EEXIST;
 		break;
 	case H_ABORTED:
-		err = -EINTR;
+		err = -EIO;
 		break;
 	default:
 		err = -EINVAL;
-- 
2.35.1



