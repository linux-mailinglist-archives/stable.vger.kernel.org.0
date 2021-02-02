Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133E330CB88
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhBBT1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:27:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233543AbhBBN7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EC5464FE4;
        Tue,  2 Feb 2021 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273570;
        bh=9if7kYq93miLSrkZTze56YJxwLXBUm96jwYKQMMnRZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrsTmysF+jclPNHcJko7C7eFecIWAAWHjcYt24tOxqDYfPxJ57SSUwq+KLlPttTKX
         ktdfRwcVoqgz5j8QpzayG2hFATPcZwSNL7QicTqYOR2C1gKmyAVjnqlKSNa54ZYvo/
         +NEauPtb6fbbIp2KbjPzL5pFgKBDet4p3Vgw5dmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurent Badel <laurentbadel@eaton.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 13/61] PM: hibernate: flush swap writer after marking
Date:   Tue,  2 Feb 2021 14:37:51 +0100
Message-Id: <20210202132947.037603925@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Badel <laurentbadel@eaton.com>

commit fef9c8d28e28a808274a18fbd8cc2685817fd62a upstream.

﻿Flush the swap writer after, not before, marking the files, to ensure the
signature is properly written.

Fixes: 6f612af57821 ("PM / Hibernate: Group swap ops")
Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -489,10 +489,10 @@ static int swap_writer_finish(struct swa
 		unsigned int flags, int error)
 {
 	if (!error) {
-		flush_swap_writer(handle);
 		pr_info("S");
 		error = mark_swapfiles(handle, flags);
 		pr_cont("|\n");
+		flush_swap_writer(handle);
 	}
 
 	if (error)


