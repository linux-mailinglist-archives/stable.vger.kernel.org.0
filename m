Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F352BA80F
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgKTLEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgKTLEX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D260B2242B;
        Fri, 20 Nov 2020 11:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870262;
        bh=OFN24E43YJvgaH4jHFbBy/LxYpvbUaHvyiPjFyTyebU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCCFBIJQT42JE0pfmmh/RBTLpdeRw0JG78bDzxSOWY4RNONCqumpWfh7GOCSPTkKM
         78sZJzOP6SM17SvpS1rw0g4APuXWqYrVLcjIwqx5LHggDL3Ir+2N4RkdyH9vfI46S/
         60yUzk7WGgYPyfIz7eehVmTvGpqYJOfDaMxLvuyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 16/16] ACPI: GED: fix -Wformat
Date:   Fri, 20 Nov 2020 12:03:21 +0100
Message-Id: <20201120104540.521558662@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
References: <20201120104539.706905067@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 9debfb81e7654fe7388a49f45bc4d789b94c1103 upstream.

Clang is more aggressive about -Wformat warnings when the format flag
specifies a type smaller than the parameter. It turns out that gsi is an
int. Fixes:

drivers/acpi/evged.c:105:48: warning: format specifies type 'unsigned
char' but the argument has type 'unsigned int' [-Wformat]
trigger == ACPI_EDGE_SENSITIVE ? 'E' : 'L', gsi);
                                            ^~~

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Fixes: ea6f3af4c5e6 ("ACPI: GED: add support for _Exx / _Lxx handler methods")
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/evged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/evged.c
+++ b/drivers/acpi/evged.c
@@ -104,7 +104,7 @@ static acpi_status acpi_ged_request_inte
 
 	switch (gsi) {
 	case 0 ... 255:
-		sprintf(ev_name, "_%c%02hhX",
+		sprintf(ev_name, "_%c%02X",
 			trigger == ACPI_EDGE_SENSITIVE ? 'E' : 'L', gsi);
 
 		if (ACPI_SUCCESS(acpi_get_handle(handle, ev_name, &evt_handle)))


