Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74CA431C1D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhJRNjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhJRNgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AFC7613D0;
        Mon, 18 Oct 2021 13:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563869;
        bh=q5fAp+YBYcdhwPHFstIh6HhVzWBCWxw8a5w7Nw9s8KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDiETysmSZndvtfoIlA0XlGGe8u4LC3FpinfgxyYYCi8A503iqeGgvafXhoZPOCfY
         +SbRt2l7M5omy+o/aVDodM5g1suI4GhMkNLA6PsEQ88MVjvT9ZZVILN/tZDqhg2i16
         XBhMqbHN/DoQVqk5XXC810D/FNJQrDpcPItC+1LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 45/69] sctp: account stream padding length for reconf chunk
Date:   Mon, 18 Oct 2021 15:24:43 +0200
Message-Id: <20211018132330.967646307@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

commit a2d859e3fc97e79d907761550dbc03ff1b36479c upstream.

sctp_make_strreset_req() makes repeated calls to sctp_addto_chunk()
which will automatically account for padding on each call. inreq and
outreq are already 4 bytes aligned, but the payload is not and doing
SCTP_PAD4(a + b) (which _sctp_make_chunk() did implicitly here) is
different from SCTP_PAD4(a) + SCTP_PAD4(b) and not enough. It led to
possible attempt to use more buffer than it was allocated and triggered
a BUG_ON.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
Reported-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/b97c1f8b0c7ff79ac4ed206fc2c49d3612e0850c.1634156849.git.mleitner@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3659,7 +3659,7 @@ struct sctp_chunk *sctp_make_strreset_re
 	outlen = (sizeof(outreq) + stream_len) * out;
 	inlen = (sizeof(inreq) + stream_len) * in;
 
-	retval = sctp_make_reconf(asoc, outlen + inlen);
+	retval = sctp_make_reconf(asoc, SCTP_PAD4(outlen) + SCTP_PAD4(inlen));
 	if (!retval)
 		return NULL;
 


