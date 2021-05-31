Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC6E39614F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhEaOiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233643AbhEaOgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4F1661C4F;
        Mon, 31 May 2021 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469081;
        bh=XSgpYZSS1A43AEYXwsuaBxUBHSVjgtsQgACDshoxKDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiQxlKXOQ/xFWhw+GQxGUBlp8fmK9ybfzpI1iXYSefAdYiZJaB+OGOxUPYe1dyyhU
         1MAmf2l5LaADamulKgbV12Ri3+z0I7K18QHiBBwV0sKvi6REOIyBIqFMQXZ1K7/4Hf
         85XYwToG9P47VFsFYQ7n+/AqPc1l5mTrV8os0uAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.12 027/296] perf scripts python: exported-sql-viewer.py: Fix copy to clipboard from Top Calls by elapsed Time report
Date:   Mon, 31 May 2021 15:11:22 +0200
Message-Id: <20210531130704.695539522@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit a6172059758ba1b496ae024cece7d5bdc8d017db upstream.

Provide missing argument to prevent following error when copying a
selection to the clipboard:

Traceback (most recent call last):
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 4041, in <lambda>
    menu.addAction(CreateAction("&Copy selection", "Copy to clipboard", lambda: CopyCellsToClipboardHdr(self.view), self.view))
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 4021, in CopyCellsToClipboardHdr
    CopyCellsToClipboard(view, False, True)
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 4018, in CopyCellsToClipboard
    view.CopyCellsToClipboard(view, as_csv, with_hdr)
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 3871, in CopyTableCellsToClipboard
    val = model.headerData(col, Qt.Horizontal)
TypeError: headerData() missing 1 required positional argument: 'role'

Fixes: 96c43b9a7ab3b ("perf scripts python: exported-sql-viewer.py: Add copy to clipboard")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20210521092053.25683-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/scripts/python/exported-sql-viewer.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -3868,7 +3868,7 @@ def CopyTableCellsToClipboard(view, as_c
 	if with_hdr:
 		model = indexes[0].model()
 		for col in range(min_col, max_col + 1):
-			val = model.headerData(col, Qt.Horizontal)
+			val = model.headerData(col, Qt.Horizontal, Qt.DisplayRole)
 			if as_csv:
 				text += sep + ToCSValue(val)
 				sep = ","


