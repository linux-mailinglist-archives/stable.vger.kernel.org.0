Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 656731455AD
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgAVNYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgAVNYN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:13 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 272B82467B;
        Wed, 22 Jan 2020 13:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699452;
        bh=CieECoi7YdqBWSVo5QJb+cYgFiEPq497RWDxtyjRnGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPB9QzYvrO22zcV/h5o5/xhV4yFvt/RVYJfuDChUjB0DqFAe27JnjH23E3CYHOEAR
         +nN+jcmI9kqq/yEs15VlVbajvpKn2aySelJsAmqSR5ssPTpycRyXoi1UEqyNLv+dmH
         dVcBP9SrHWLqSaET2kJZFc2yzt6H4ZWc/Y0WMUc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: [PATCH 5.4 114/222] bpf: Sockmap/tls, skmsg can have wrapped skmsg that needs extra chaining
Date:   Wed, 22 Jan 2020 10:28:20 +0100
Message-Id: <20200122092841.894240359@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 9aaaa56845a06aeabdd597cbe19492dc01f281ec upstream.

Its possible through a set of push, pop, apply helper calls to construct
a skmsg, which is just a ring of scatterlist elements, with the start
value larger than the end value. For example,

      end       start
  |_0_|_1_| ... |_n_|_n+1_|

Where end points at 1 and start points and n so that valid elements is
the set {n, n+1, 0, 1}.

Currently, because we don't build the correct chain only {n, n+1} will
be sent. This adds a check and sg_chain call to correctly submit the
above to the crypto and tls send path.

Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20200111061206.8028-8-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tls/tls_sw.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -724,6 +724,12 @@ static int tls_push_record(struct sock *
 		sg_mark_end(sk_msg_elem(msg_pl, i));
 	}
 
+	if (msg_pl->sg.end < msg_pl->sg.start) {
+		sg_chain(&msg_pl->sg.data[msg_pl->sg.start],
+			 MAX_SKB_FRAGS - msg_pl->sg.start + 1,
+			 msg_pl->sg.data);
+	}
+
 	i = msg_pl->sg.start;
 	sg_chain(rec->sg_aead_in, 2, &msg_pl->sg.data[i]);
 


