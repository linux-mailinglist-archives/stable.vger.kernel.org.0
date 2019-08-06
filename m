Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F223829E4
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 05:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfHFDII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 23:08:08 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:34307 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbfHFDII (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 23:08:08 -0400
Received: by mail-vs1-f68.google.com with SMTP id m23so57398103vso.1;
        Mon, 05 Aug 2019 20:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMT+gT6D225+qp+FOpL46f/S7PPq1vz7DseBHSVYmg4=;
        b=bW3Z8KnWBEnHEkaAOnQu1G1oz1vEnFHUV44VZgEk6A6RyTeiTbPcVF+5RVXkXiFZ7N
         0P0qobpRriowWkEQ95AQxs1wnYa3+e4oiAwlkFD1eUjMKCB8mlX4zyK4nXMnDf+WgI+b
         aPw1WUONRkQxd+hKEbjV3ecd7u+DmTSj58r4tZ+0NhUlenskHHa9eIQ7kHj3uZr52lA0
         6JmY6LOhP4eAuxTURl98Oa6Mn+4TIyG2VrBCGKhpt/ugSm+SZTyGsFafeoPnakX1AJd7
         a50cwiwqoQhcQZQ2bw4tRG5On+C2gPCl55D9LrRtLgdYn0zDzvvsU4b4KJyarJIRO1X+
         mVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMT+gT6D225+qp+FOpL46f/S7PPq1vz7DseBHSVYmg4=;
        b=b8+rCZg/6AS0xyFzrbf5hd7JzM2Yy9TxMIemFDGsLgfFVzcQlUHs8zOB6lHwRBmyzq
         p6ZxtQ5yafptLyMBtQd5N8MYSVyhC4TLnTccUgTMo4neNjxRDvxr2ekGO20VI2VutJqv
         M20Rh0ykl8El80sZ17H+hfbknm+X0IOwrw2FYMuUYh83YvFW1/8d0vABlBcWfBy69R4E
         Dvat/rwD7p3Z12+HTg+PkcWHsQgGLqmO6RNimL7sZQBGkwNgJQVQ3rVzKtJd23Xxa9pd
         /Q4Byu2BSBmd5bCmsj94qKNsOG4HVffZHJSydf1gyFq0qG751PNpdEtlLtaAYYJ9mdAq
         9q8Q==
X-Gm-Message-State: APjAAAU4vByJekziShE7KU/bnPRds5NpF/9VL0RV1cyprD0CKJ7uu/Bo
        3Iq5KGI/+vOeJjDD3F2A6bo=
X-Google-Smtp-Source: APXvYqyQhSa41qyKIL5M4jJigx57/1DGGRJ0WESsNgcXpaf1vNoLqbRgtkVv9vmQZX05GnjCZCqW1w==
X-Received: by 2002:a67:f8d4:: with SMTP id c20mr853660vsp.239.1565060886854;
        Mon, 05 Aug 2019 20:08:06 -0700 (PDT)
Received: from asus-S451LA.lan ([190.22.46.249])
        by smtp.gmail.com with ESMTPSA id v190sm22683156vkd.37.2019.08.05.20.08.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 20:08:06 -0700 (PDT)
From:   Luis Araneda <luaraneda@gmail.com>
To:     linux@armlinux.org.uk, michal.simek@xilinx.com
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Luis Araneda <luaraneda@gmail.com>
Subject: [PATCH 0/2] ARM: zynq: smp improvements
Date:   Mon,  5 Aug 2019 23:07:16 -0400
Message-Id: <20190806030718.29048-1-luaraneda@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series adds support for kernel compiled in Thumb mode
and fixes a kernel panic on smp bring-up when FORTIFY_SOURCE
is enabled.

The series started with the second patch as an RFC, and
the first patch were suggested on the review to complement
the fix.

The changes were run-tested on a Digilent Zybo Z7 board

Luis Araneda (2):
  ARM: zynq: support smp in thumb mode
  ARM: zynq: Use memcpy_toio instead of memcpy on smp bring-up

 arch/arm/mach-zynq/headsmp.S | 2 ++
 arch/arm/mach-zynq/platsmp.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.22.0

