Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AEC3ED5A8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237408AbhHPNNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239494AbhHPNLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D9F86329B;
        Mon, 16 Aug 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119408;
        bh=Y3LrwcJXlunsJKDo9+kyZzdFI3Ja8tF0U6CMl8ERqF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJhn5xh6V1MdHmAzvNHsjW8/l+KibJa/Pfxn+GPloLIzJTnfDRH7QjiCa/OV4yLG+
         QRA3vFCbOJCeSai04384cLfClIL5VgLWtPBjn9SlGgIKMscI70MKaRoRXA3cVztdtf
         geQ7Bj9tlG5z2eqMtSYSl297Ig+lw/bSqbiDob7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 015/151] cifs: create sd context must be a multiple of 8
Date:   Mon, 16 Aug 2021 15:00:45 +0200
Message-Id: <20210816125444.576975230@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 7d3fc01796fc895e5fcce45c994c5a8db8120a8d upstream.

We used to follow the rule earlier that the create SD context
always be a multiple of 8. However, with the change:
cifs: refactor create_sd_buf() and and avoid corrupting the buffer
...we recompute the length, and we failed that rule.
Fixing that with this change.

Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2375,7 +2375,7 @@ create_sd_buf(umode_t mode, bool set_own
 	memcpy(aclptr, &acl, sizeof(struct cifs_acl));
 
 	buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);
-	*len = ptr - (__u8 *)buf;
+	*len = roundup(ptr - (__u8 *)buf, 8);
 
 	return buf;
 }


