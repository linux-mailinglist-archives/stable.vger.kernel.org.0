Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4381C6E7
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 12:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfENKUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 06:20:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33807 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfENKUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 06:20:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id n19so8906235pfa.1
        for <stable@vger.kernel.org>; Tue, 14 May 2019 03:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=researchut.com; s=google;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kSvbP/JUEyjknkS6lpDdv2UR88rYqz8vK8aOSF/0SV0=;
        b=w+nl5EeDp2p7umtRRO82DdYvY0tL1DucblxdSv7fnksZ69dMEf0m7sodXpjJxQ96Dq
         bFP5MdEo7Q/dpKeslQSssn2MLoHlqz5ncNj01LtWuAOrnicfjFHFyetqQyp2ByYOQCxr
         as2nZOoe6Gug4MHocGs6HxjfiaiPx2L5HHaYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=kSvbP/JUEyjknkS6lpDdv2UR88rYqz8vK8aOSF/0SV0=;
        b=ZoUtC3KS1tRwiBIywEnPekCfTUTHlmFKTq42VBLJXfRg0DctGhGmLTsnXST247CaOh
         sVeK0i9AYUdPDQ3yDfs3jSEsv5dQh5NxwxL92+s/LXxByXXdTJBVnJfpNaaznh3gM3Rn
         iNz0i970ItxW9VaTrzpS614YOK/MH+kYDmgczJGY6M2pEGstE3/mrnS7qIkcDl2z8LJC
         LsfRiNCPKUvlCs81RRbN565LT09i1l4D4TCGfLBxYJ7R+Yau8u7Zjyi8x7TozmLJ0JEl
         qeeyksmvX9h9aUSDy0uR3/LTogSdtDoMbj8/nsnZaczty1cTIlVwe5XGkdl8lk8jBpBD
         sV9w==
X-Gm-Message-State: APjAAAVHApx/cLA9FXqAmycYdItYvs8EQUZfwuYtsTFxO4houKcXjYhn
        hVQRcl/rBImfIMhzLKV36nmm8rv9mLk=
X-Google-Smtp-Source: APXvYqxgtnsOnwpKzzwuu+UtI2PENo1P06Fk75O7J31mPCuBiNOLb4RxYgbS6iVkgesBMmK2xeZ/Fg==
X-Received: by 2002:a63:1d02:: with SMTP id d2mr37704091pgd.26.1557829211409;
        Tue, 14 May 2019 03:20:11 -0700 (PDT)
Received: from priyasi ([157.45.46.216])
        by smtp.gmail.com with ESMTPSA id k9sm22337550pfa.180.2019.05.14.03.20.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 03:20:10 -0700 (PDT)
Received: from [127.0.0.1] (helo=priyasi.researchut.com)
        by priyasi with esmtp (Exim 4.92)
        (envelope-from <rrs@debian.org>)
        id 1hQUXM-0002h9-F0; Tue, 14 May 2019 15:49:56 +0530
From:   Ritesh Raj Sarraf <rrs@debian.org>
To:     stable@vger.kernel.org
Cc:     debian-kernel@lists.debian.org, Ritesh Raj Sarraf <rrs@debian.org>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Don't hardcode path as it is architecture dependent
Date:   Tue, 14 May 2019 15:46:57 +0530
Message-Id: <20190514101656.10228-1-rrs@debian.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Stable Team,
Request for inclusion into the stable branches of Linux. This change
went into 4.20 but 4.19 is the LTS release that many of the Linux
Vendors are rebasing on. Hence, it'd be nice to see this part of the LTS
releases, at least 4.19.


The current code fails to run on amd64 because of hardcoded reference to
i386

Signed-off-by: Ritesh Raj Sarraf <rrs@researchut.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/port_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
index 9a8e1b64c22e..5f56d11b886f 100644
--- a/arch/um/drivers/port_user.c
+++ b/arch/um/drivers/port_user.c
@@ -168,7 +168,7 @@ int port_connection(int fd, int *socket, int *pid_out)
 {
 	int new, err;
 	char *argv[] = { "/usr/sbin/in.telnetd", "-L",
-			 "/usr/lib/uml/port-helper", NULL };
+			 OS_LIB_PATH "/uml/port-helper", NULL };
 	struct port_pre_exec_data data;
 
 	new = accept(fd, NULL, 0);
-- 
2.20.1

