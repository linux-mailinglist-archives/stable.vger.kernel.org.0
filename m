Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FEA2FA2BE
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbhAROSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390480AbhARLpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB49B222B3;
        Mon, 18 Jan 2021 11:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970269;
        bh=o0NgGZznWG8v395Wg0GQaU1J61UYGzexnuob+BbaEwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lq+zDRQiLuD5qo8l5XmPXVJ8l7Wj44zEs9u9iAJGQChoo1KTwpxkwPeEtQuz1W4K3
         KY7ROwADfSiqRJ0CO0YQg+R+4csrzqt7l0Fkqh6mRj0BLiGltN5VV7yVNPt6BxqQOR
         NYIbhQiEjHcTfhNpbzJrdAIAOsaQ+d7ecjI20UTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Borislav Petkov <bp@suse.de>,
        David Rientjes <rientjes@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/152] x86/sev-es: Fix SEV-ES OUT/IN immediate opcode vc handling
Date:   Mon, 18 Jan 2021 12:34:36 +0100
Message-Id: <20210118113357.584106124@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

[ Upstream commit a8f7e08a81708920a928664a865208fdf451c49f ]

The IN and OUT instructions with port address as an immediate operand
only use an 8-bit immediate (imm8). The current VC handler uses the
entire 32-bit immediate value but these instructions only set the first
bytes.

Cast the operand to an u8 for that.

 [ bp: Massage commit message. ]

Fixes: 25189d08e5168 ("x86/sev-es: Add support for handling IOIO exceptions")
Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Link: https://lkml.kernel.org/r/20210105163311.221490-1-pgonda@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/sev-es-shared.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index 7d04b356d44d3..cdc04d0912423 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -305,14 +305,14 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 	case 0xe4:
 	case 0xe5:
 		*exitinfo |= IOIO_TYPE_IN;
-		*exitinfo |= (u64)insn->immediate.value << 16;
+		*exitinfo |= (u8)insn->immediate.value << 16;
 		break;
 
 	/* OUT immediate opcodes */
 	case 0xe6:
 	case 0xe7:
 		*exitinfo |= IOIO_TYPE_OUT;
-		*exitinfo |= (u64)insn->immediate.value << 16;
+		*exitinfo |= (u8)insn->immediate.value << 16;
 		break;
 
 	/* IN register opcodes */
-- 
2.27.0



