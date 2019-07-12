Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE866D3F
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfGLM14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:27:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbfGLM1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:27:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18CD821019;
        Fri, 12 Jul 2019 12:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934475;
        bh=29XoS77K21tgMNHk4T910ZD4vgXDxrf+LXa6VRmNcJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bf58cF4C+isX2SguepMfmLrM8M7J7SAWA25J2ZzDkISH8+PvkaO3CmGt0QA+7M3DU
         oqSYnrzXnLzBGUdUAIRhH0IBAc+x5BaxWJaXOytiryDXVIueekNJlzhbyYY/rk1oEw
         sbNV6WIH5biS3QYz/8LeGaXiAXnEARKGqgzv/MGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 030/138] tools: bpftool: Fix JSON output when lookup fails
Date:   Fri, 12 Jul 2019 14:18:14 +0200
Message-Id: <20190712121629.852592026@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1884c066579a7a274dd981a4d9639ca63db66a23 ]

In commit 9a5ab8bf1d6d ("tools: bpftool: turn err() and info() macros
into functions") one case of error reporting was special cased, so it
could report a lookup error for a specific key when dumping the map
element. What the code forgot to do is to wrap the key and value keys
into a JSON object, so an example output of pretty JSON dump of a
sockhash map (which does not support looking up its values) is:

[
    "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x00"
    ],
    "value": {
        "error": "Operation not supported"
    },
    "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x01"
    ],
    "value": {
        "error": "Operation not supported"
    }
]

Note the key-value pairs inside the toplevel array. They should be
wrapped inside a JSON object, otherwise it is an invalid JSON. This
commit fixes this, so the output now is:

[{
        "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x00"
        ],
        "value": {
            "error": "Operation not supported"
        }
    },{
        "key": ["0x0a","0x41","0x00","0x02","0x1f","0x78","0x00","0x01"
        ],
        "value": {
            "error": "Operation not supported"
        }
    }
]

Fixes: 9a5ab8bf1d6d ("tools: bpftool: turn err() and info() macros into functions")
Cc: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 994a7e0d16fb..14f581b562bd 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -713,12 +713,14 @@ static int dump_map_elem(int fd, void *key, void *value,
 		return 0;
 
 	if (json_output) {
+		jsonw_start_object(json_wtr);
 		jsonw_name(json_wtr, "key");
 		print_hex_data_json(key, map_info->key_size);
 		jsonw_name(json_wtr, "value");
 		jsonw_start_object(json_wtr);
 		jsonw_string_field(json_wtr, "error", strerror(lookup_errno));
 		jsonw_end_object(json_wtr);
+		jsonw_end_object(json_wtr);
 	} else {
 		if (errno == ENOENT)
 			print_entry_plain(map_info, key, NULL);
-- 
2.20.1



