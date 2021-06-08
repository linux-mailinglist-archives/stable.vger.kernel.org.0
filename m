Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AAF3A01B0
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbhFHSzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236202AbhFHSw4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:52:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3FD861482;
        Tue,  8 Jun 2021 18:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177627;
        bh=jdRzOxJhc7bDRmRfhJGpruhglj34+7u7uf+BVQ4T7+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTQ78bTiCqyBU/fwSJU6/jF30kIlVjpCM/9n5nP2WxAjRGL+R2h4Y4UyntlrPNUtS
         WyKRdCzJjwVbopU2CiwKqI6Zc7OrZspGwLXI65+Y/N/R0Obc6VFhjxaWXiGfCAD2xi
         J7vly6viP/y+gRwLTPbydzmvK1l0uq1eGnbeoQ+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/137] efi/libstub: prevent read overflow in find_file_option()
Date:   Tue,  8 Jun 2021 20:25:48 +0200
Message-Id: <20210608175942.668115405@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c4039b29fe9637e1135912813f830994af4c867f ]

If the buffer has slashes up to the end then this will read past the end
of the array.  I don't anticipate that this is an issue for many people
in real life, but it's the right thing to do and it makes static
checkers happy.

Fixes: 7a88a6227dc7 ("efi/libstub: Fix path separator regression")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/file.c b/drivers/firmware/efi/libstub/file.c
index 4e81c6077188..dd95f330fe6e 100644
--- a/drivers/firmware/efi/libstub/file.c
+++ b/drivers/firmware/efi/libstub/file.c
@@ -103,7 +103,7 @@ static int find_file_option(const efi_char16_t *cmdline, int cmdline_len,
 		return 0;
 
 	/* Skip any leading slashes */
-	while (cmdline[i] == L'/' || cmdline[i] == L'\\')
+	while (i < cmdline_len && (cmdline[i] == L'/' || cmdline[i] == L'\\'))
 		i++;
 
 	while (--result_len > 0 && i < cmdline_len) {
-- 
2.30.2



