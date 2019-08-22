Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA499BE4
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404668AbfHVR0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404664AbfHVR0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:13 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A2E12341C;
        Thu, 22 Aug 2019 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494773;
        bh=rC0zqd/Pa/S7+DOCJZLzaOR/jw40gKJ1bDUaQK1c0Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICjFLMrTWS37iJZ/W8t3W8jOvMWJpVb+80ifKi5Nw2DRPi4nP7njKWWXp/Y06Bk6L
         XyaHS4JmVHRPwt73qYEVDCcH0iYECOtJW+Bfflg+RTwUMPFaqF/StO6mzsqRQEJUtu
         +0p7ANaGIH1B8A25gUayJujeylZwS6CrN2dIuOdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        zhengbin <zhengbin13@huawei.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.19 78/85] sctp: fix memleak in sctp_send_reset_streams
Date:   Thu, 22 Aug 2019 10:19:51 -0700
Message-Id: <20190822171734.481850470@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 6d5afe20397b478192ed8c38ec0ee10fa3aec649 ]

If the stream outq is not empty, need to kfree nstr_list.

Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -416,6 +416,7 @@ int sctp_send_reset_streams(struct sctp_
 		nstr_list[i] = htons(str_list[i]);
 
 	if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
+		kfree(nstr_list);
 		retval = -EAGAIN;
 		goto out;
 	}


