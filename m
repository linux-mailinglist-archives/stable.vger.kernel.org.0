Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE02428F6A
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbhJKN6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237070AbhJKN43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:56:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4C826112D;
        Mon, 11 Oct 2021 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960407;
        bh=SzGh1Rg94Y+qKrv3/B+mC5SIKGHpGzNVCR/AXa86xLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JS3Q26TUMwC9zc60vUYkPqthcVQ21jERp51Fu2PfOb00Cr5aMNFkN2GQnDNjikvc0
         7Bl0vOGn7JGGo+JJ0gKo/h/5Wotya8BAxmyIpvBa6JpvYx7i2t+nQa52GnGsFNRZC0
         Kiflo7mBRxYhChnRfNeYbSY6iD2Sd8LDYAy6T7mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/83] perf jevents: Tidy error handling
Date:   Mon, 11 Oct 2021 15:46:12 +0200
Message-Id: <20211011134510.196249945@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit fa1b41a74d1136cbdd6960f36d7b9c7aa35c8139 ]

There is much duplication in the error handling for directory transvering
for prcessing JSONs.

Factor out the common code to tidy a bit.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-By: Kajol Jain<kjain@linux.ibm.com>
Link: https://lore.kernel.org/r/1603364547-197086-2-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.c | 83 ++++++++++++++-------------------
 1 file changed, 35 insertions(+), 48 deletions(-)

diff --git a/tools/perf/pmu-events/jevents.c b/tools/perf/pmu-events/jevents.c
index dcfdf6a322dc..c679a79aef51 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -1100,12 +1100,13 @@ static int process_one_file(const char *fpath, const struct stat *sb,
  */
 int main(int argc, char *argv[])
 {
-	int rc, ret = 0;
+	int rc, ret = 0, empty_map = 0;
 	int maxfds;
 	char ldirname[PATH_MAX];
 	const char *arch;
 	const char *output_file;
 	const char *start_dirname;
+	char *err_string_ext = "";
 	struct stat stbuf;
 
 	prog = basename(argv[0]);
@@ -1133,7 +1134,8 @@ int main(int argc, char *argv[])
 	/* If architecture does not have any event lists, bail out */
 	if (stat(ldirname, &stbuf) < 0) {
 		pr_info("%s: Arch %s has no PMU event lists\n", prog, arch);
-		goto empty_map;
+		empty_map = 1;
+		goto err_close_eventsfp;
 	}
 
 	/* Include pmu-events.h first */
@@ -1150,75 +1152,60 @@ int main(int argc, char *argv[])
 	 */
 
 	maxfds = get_maxfds();
-	mapfile = NULL;
 	rc = nftw(ldirname, preprocess_arch_std_files, maxfds, 0);
-	if (rc && verbose) {
-		pr_info("%s: Error preprocessing arch standard files %s\n",
-			prog, ldirname);
-		goto empty_map;
-	} else if (rc < 0) {
-		/* Make build fail */
-		fclose(eventsfp);
-		free_arch_std_events();
-		return 1;
-	} else if (rc) {
-		goto empty_map;
-	}
+	if (rc)
+		goto err_processing_std_arch_event_dir;
 
 	rc = nftw(ldirname, process_one_file, maxfds, 0);
-	if (rc && verbose) {
-		pr_info("%s: Error walking file tree %s\n", prog, ldirname);
-		goto empty_map;
-	} else if (rc < 0) {
-		/* Make build fail */
-		fclose(eventsfp);
-		free_arch_std_events();
-		ret = 1;
-		goto out_free_mapfile;
-	} else if (rc) {
-		goto empty_map;
-	}
+	if (rc)
+		goto err_processing_dir;
 
 	sprintf(ldirname, "%s/test", start_dirname);
 
 	rc = nftw(ldirname, process_one_file, maxfds, 0);
-	if (rc && verbose) {
-		pr_info("%s: Error walking file tree %s rc=%d for test\n",
-			prog, ldirname, rc);
-		goto empty_map;
-	} else if (rc < 0) {
-		/* Make build fail */
-		free_arch_std_events();
-		ret = 1;
-		goto out_free_mapfile;
-	} else if (rc) {
-		goto empty_map;
-	}
+	if (rc)
+		goto err_processing_dir;
 
 	if (close_table)
 		print_events_table_suffix(eventsfp);
 
 	if (!mapfile) {
 		pr_info("%s: No CPU->JSON mapping?\n", prog);
-		goto empty_map;
+		empty_map = 1;
+		goto err_close_eventsfp;
 	}
 
-	if (process_mapfile(eventsfp, mapfile)) {
+	rc = process_mapfile(eventsfp, mapfile);
+	fclose(eventsfp);
+	if (rc) {
 		pr_info("%s: Error processing mapfile %s\n", prog, mapfile);
 		/* Make build fail */
-		fclose(eventsfp);
-		free_arch_std_events();
 		ret = 1;
+		goto err_out;
 	}
 
+	free_arch_std_events();
+	free(mapfile);
+	return 0;
 
-	goto out_free_mapfile;
-
-empty_map:
+err_processing_std_arch_event_dir:
+	err_string_ext = " for std arch event";
+err_processing_dir:
+	if (verbose) {
+		pr_info("%s: Error walking file tree %s%s\n", prog, ldirname,
+			err_string_ext);
+		empty_map = 1;
+	} else if (rc < 0) {
+		ret = 1;
+	} else {
+		empty_map = 1;
+	}
+err_close_eventsfp:
 	fclose(eventsfp);
-	create_empty_mapping(output_file);
+	if (empty_map)
+		create_empty_mapping(output_file);
+err_out:
 	free_arch_std_events();
-out_free_mapfile:
 	free(mapfile);
 	return ret;
 }
-- 
2.33.0



