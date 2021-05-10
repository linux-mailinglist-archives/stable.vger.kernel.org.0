Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF793785EF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhEJLCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234766AbhEJK5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A74D619B9;
        Mon, 10 May 2021 10:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643739;
        bh=cFzoFc2FSTUDTJ9I0MNr5aMOG8GsOPwuxgKpJxNMDgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPksT3RMo1JbiI+U6s2IFOIk3hiTGnm8pobxuOX/HfvCOZ9enkNsj3KYluAWOJams
         30R4Al5NsNLqPPUCE2TJn5qMkQcpZwPaxqUHn9NhLYKAfKaDaz/Ro2im4JhLXmP0ym
         qmXXNfB0oiVAu7iAKXrhABihCgxnWpJj+vhh7v2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 103/342] tools/power/x86/intel-speed-select: Increase string size
Date:   Mon, 10 May 2021 12:18:13 +0200
Message-Id: <20210510102013.507691332@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 2e70b710f36c80b6e78cf32a5c30b46dbb72213c ]

The current string size to print cpulist can accommodate upto 80
logical CPUs per package. But this limit is not enough. So increase
the string size. Also prevent buffer overflow, if the string size
reaches limit.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-display.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/intel-speed-select/isst-display.c b/tools/power/x86/intel-speed-select/isst-display.c
index e105fece47b6..f32ce0362eb7 100644
--- a/tools/power/x86/intel-speed-select/isst-display.c
+++ b/tools/power/x86/intel-speed-select/isst-display.c
@@ -25,10 +25,14 @@ static void printcpulist(int str_len, char *str, int mask_size,
 			index = snprintf(&str[curr_index],
 					 str_len - curr_index, ",");
 			curr_index += index;
+			if (curr_index >= str_len)
+				break;
 		}
 		index = snprintf(&str[curr_index], str_len - curr_index, "%d",
 				 i);
 		curr_index += index;
+		if (curr_index >= str_len)
+			break;
 		first = 0;
 	}
 }
@@ -64,10 +68,14 @@ static void printcpumask(int str_len, char *str, int mask_size,
 		index = snprintf(&str[curr_index], str_len - curr_index, "%08x",
 				 mask[i]);
 		curr_index += index;
+		if (curr_index >= str_len)
+			break;
 		if (i) {
 			strncat(&str[curr_index], ",", str_len - curr_index);
 			curr_index++;
 		}
+		if (curr_index >= str_len)
+			break;
 	}
 
 	free(mask);
@@ -185,7 +193,7 @@ static void _isst_pbf_display_information(int cpu, FILE *outf, int level,
 					  int disp_level)
 {
 	char header[256];
-	char value[256];
+	char value[512];
 
 	snprintf(header, sizeof(header), "speed-select-base-freq-properties");
 	format_and_print(outf, disp_level, header, NULL);
@@ -349,7 +357,7 @@ void isst_ctdp_display_information(int cpu, FILE *outf, int tdp_level,
 				   struct isst_pkg_ctdp *pkg_dev)
 {
 	char header[256];
-	char value[256];
+	char value[512];
 	static int level;
 	int i;
 
-- 
2.30.2



