Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD615428F24
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbhJKNzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237967AbhJKNxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA0C6103C;
        Mon, 11 Oct 2021 13:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960291;
        bh=z0R2Nz3ELb5auMqIhCpY+rn/E2/77H3AVItM0bh2lAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06iH+XE4qXAkv9Dxsz2zzeUW6pzmmsB/zq3vtE3K8oe2Dm/24se86ag+MW5CUXDNk
         hrMuQil+gnjCZ5nFvbMAIzcAGYbdn4f1Akj5fP34zP0WWj9LsjFGVop83zvlVixyjI
         2Jc4wQfzRIWVwJy5dwwba07PNaHBwCiOSWFk843k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/83] bus: ti-sysc: Add break in switch statement in sysc_init_soc()
Date:   Mon, 11 Oct 2021 15:45:41 +0200
Message-Id: <20211011134509.089638723@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit e879f855e590b40fe3c79f2fbd8f65ca3c724120 ]

After commit a6d90e9f2232 ("bus: ti-sysc: AM3: RNG is GP only"), clang
with -Wimplicit-fallthrough enabled warns:

drivers/bus/ti-sysc.c:2958:3: warning: unannotated fall-through between
switch labels [-Wimplicit-fallthrough]
                default:
                ^
drivers/bus/ti-sysc.c:2958:3: note: insert 'break;' to avoid
fall-through
                default:
                ^
                break;
1 warning generated.

Clang's version of this warning is a little bit more pedantic than
GCC's. Add the missing break to satisfy it to match what has been done
all over the kernel tree.

Fixes: a6d90e9f2232 ("bus: ti-sysc: AM3: RNG is GP only")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 159b57c6dc4d..d2b7338c073f 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2922,6 +2922,7 @@ static int sysc_init_soc(struct sysc *ddata)
 			break;
 		case SOC_AM3:
 			sysc_add_disabled(0x48310000);  /* rng */
+			break;
 		default:
 			break;
 		};
-- 
2.33.0



