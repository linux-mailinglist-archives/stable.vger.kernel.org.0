Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1934F378902
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbhEJLZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233693AbhEJLOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1A24613D6;
        Mon, 10 May 2021 11:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645051;
        bh=QANS0ljvnCnbRtvgpWtW/mVl6DnT7ZXLlvRU1ul8g3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XD+9r+hN13Pnu7EBm2hQcWK/GOhwVlX0FOWwP2Frcp8FXcx7w/bRVE7j+fewMgmys
         kLx94Peogsjam8ssRnK+PN6s756vTjhJL0qXRGM2z+4II8g8qye/nEJ32Y3DiAwBc8
         RIdi/Q7Y3DEZHkwGOHq+8Nk1IyUHr6RObZqd9+Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 5.12 330/384] smb3: if max_channels set to more than one channel request multichannel
Date:   Mon, 10 May 2021 12:21:59 +0200
Message-Id: <20210510102025.672915080@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

commit c1f8a398b6d661b594556a91224b096d92293061 upstream.

Mounting with "multichannel" is obviously implied if user requested
more than one channel on mount (ie mount parm max_channels>1).
Currently both have to be specified. Fix that so that if max_channels
is greater than 1 on mount, enable multichannel rather than silently
falling back to non-multichannel.

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-By: Tom Talpey <tom@talpey.com>
Cc: <stable@vger.kernel.org> # v5.11+
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/fs_context.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -999,6 +999,9 @@ static int smb3_fs_context_parse_param(s
 			goto cifs_parse_mount_err;
 		}
 		ctx->max_channels = result.uint_32;
+		/* If more than one channel requested ... they want multichan */
+		if (result.uint_32 > 1)
+			ctx->multichannel = true;
 		break;
 	case Opt_handletimeout:
 		ctx->handle_timeout = result.uint_32;


