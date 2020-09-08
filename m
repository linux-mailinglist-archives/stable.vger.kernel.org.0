Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B651261925
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbgIHSHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731471AbgIHQLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FACB2476E;
        Tue,  8 Sep 2020 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579714;
        bh=t7T7Hv6djcVNu/mOs3I8WDKRkVDXHKWlUme4E61ZPk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ny3Aq1fEeVaZyONwaRmASghpy582Q1IoDXOTl7z4rXsSNi/pGueMgFPPMcD5bzMLO
         W89pHkkwxU8E8AcQJc3+N/xJFklZbIYvDQxbxZ9KLbnsYe2PAe9CyR/B3gY5Z2HCXG
         FAj59PoL6A4bkM9wXQUBIRnBV5NIeGYaitYiPXrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.8 178/186] kconfig: streamline_config.pl: check defined(ENV variable) before using it
Date:   Tue,  8 Sep 2020 17:25:20 +0200
Message-Id: <20200908152250.297499295@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit a73fbfce2cc28883f659414d598e6e60ca2214b4 upstream.

A user reported:
'Use of uninitialized value $ENV{"LMC_KEEP"} in split at
 ./scripts/kconfig/streamline_config.pl line 596.'

so first check that $ENV{LMC_KEEP} is defined before trying
to use it.

Fixes: c027b02d89fd ("streamline_config.pl: add LMC_KEEP to preserve some kconfigs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/kconfig/streamline_config.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -593,7 +593,10 @@ while ($repeat) {
 }
 
 my %setconfigs;
-my @preserved_kconfigs = split(/:/,$ENV{LMC_KEEP});
+my @preserved_kconfigs;
+if (defined($ENV{'LMC_KEEP'})) {
+	@preserved_kconfigs = split(/:/,$ENV{LMC_KEEP});
+}
 
 sub in_preserved_kconfigs {
     my $kconfig = $config2kfile{$_[0]};


